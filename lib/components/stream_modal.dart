import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants.dart';
import '../engine.dart';
import 'floating_buttons.dart';

// ignore: must_be_immutable
class StreamModal extends StatefulWidget {
  late BuildContext context;
  late Engine engine;
  late Function onDone;
  late Function onReflector;

  StreamModal(
    BuildContext context,
    Engine engine,
    Function onDone,
    Function onReflector,
  ) {
    this.context = context;
    this.engine = engine;
    this.onDone = onDone;
    this.onReflector = onReflector;
  }

  @override
  _StreamModal createState() => _StreamModal(
        context,
        engine,
        onDone,
        onReflector,
      );
}

class _StreamModal extends State<StreamModal> {
  _StreamModal(
    BuildContext context,
    Engine engine,
    Function onDone,
    Function onReflector,
  ) {
    this.context = context;
    this.engine = engine;
    this.onDone = onDone;
    this.onReflector = onReflector;
  }

  late BuildContext context;
  late Engine engine;
  late Function onDone;
  late Function onReflector;

  final controller = ScrollController();
  int itemIndex = 0;
  int perPage = 20;
  bool hasMore = true;
  bool isLoading = false;

  List<String> items = [];

  Timer _reflectorTimer = new Timer(Duration(seconds: 1), () {});

  Future _fetchKeepers() async {
    if (engine.reflectorSite.isEmpty) {
      return;
    }

    String urlString = "";
    String encoded;
    Uri url;

    urlString = engine.reflectorSite;
    urlString += "/keepers/json";

    encoded = Uri.encodeFull(urlString);
    url = Uri.parse(encoded);

    List<String> names = [];
    try {
      http.Response response = await http.get(url);
      final data = jsonDecode(response.body);
      for (int i = 0; i < data['keepers'].length; i++) {
        names.add(data['keepers'][i]);
      }
    } catch (exception, message) {
      print(exception);
      print(message);
    }
    if (names.isNotEmpty) {
      engine.possibleKeepers = names.join(",");
    }
  }

  Future _fetchAll(int offset, int count) async {
    if (engine.reflectorSite.isEmpty) {
      return;
    }

    String urlString = "";
    String encoded;
    Uri url;

    urlString = engine.reflectorSite;
    urlString += "/json";
    if (offset >= 0) {
      urlString += "?offset=" + offset.toString();
    } else {
      urlString += "?offset=0";
    }
    if (count >= 0) {
      urlString += "&count=" + count.toString();
    }
    if (engine.scoreKeeper.isNotEmpty && engine.scoreKeeper != "*") {
      urlString += "&names=" + engine.scoreKeeper;
    }

    encoded = Uri.encodeFull(urlString);
    url = Uri.parse(encoded);
    //print(url);

    try {
      http.Response response = await http.get(url);
      //print(response.body);
      final data = jsonDecode(response.body);
      //print(data);

      setState(() {
        List<String> newItems = [];
        for (int i = 0; i < data['all'].length; i++) {
          newItems.add(data['all'][i]);
        }
        items.addAll(newItems);
        if (data['all'].length < count) {
          hasMore = false;
        }
      });
    } catch (exception, message) {
      print(exception);
      print(message);
    }
  }

  Future _fetch() async {
    if (isLoading) return;
    isLoading = true;

    await _fetchKeepers();
    await _fetchAll(itemIndex, perPage);
    itemIndex += perPage;
    isLoading = false;
  }

  Future<void> _launchUrl(String urlString) async {
    Uri _url = Uri.parse(urlString);
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }

  @override
  void initState() {
    super.initState();

    _fetch();

    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        _fetch();
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _saveEngine() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('engine', engine.pack());
  }

  void _fromEngine() async {
    setState(() {
      // fontType = this.engine.fontType;
    });
  }

  void _refreshReflector() async {
    items = [];
    itemIndex = 0;
    _fetch();

    // start timer to auto refrest the reflector
    _reflectorTimer.cancel();
    if (engine.reflectorInterval10 ||
        engine.reflectorInterval30 ||
        engine.reflectorInterval60) {
      var seconds = 0;
      if (engine.reflectorInterval10) seconds += 10;
      if (engine.reflectorInterval30) seconds += 30;
      if (engine.reflectorInterval60) seconds += 60;
      var reflectorInterval = Duration(seconds: seconds);
      _reflectorTimer = new Timer.periodic(
        reflectorInterval,
        (Timer timer) {
          _refreshReflector();
        },
      );
    }

    //Navigator.of(context).pop();
  }

  void _savePending() async {
    _fromEngine();
    _saveEngine();
    items = [];
    itemIndex = 0;
    _fetch();
    Navigator.of(context).pop();
  }

  void _saveReflector() async {
    _fromEngine();
    _saveEngine();
    Navigator.of(context).pop();
  }

  Widget _buildListTile(String item) {
    Widget result = SizedBox.shrink();

    // RAW
    if (engine.showRaw) {
      List<String> parts = item.split(",");
      List<String> newParts = [];

      // time keeper colorA1 colorA2 colorB1 colorB2 nameA nameB setsA setsB scoreA scoreB possesion
      // 0    1      2       3       4       5       6     7     8     9     10     11     12
      // time keeper colorA1 colorA2 colorB1 colorB2 nameA nameB setsA setsB scoreA scoreB possesion font zoom     sets5    setsShow
      // 0    1      2       3       4       5       6     7     8     9     10     11     12        13   14       15       16
      //                                                                                   1|2       str  zoomOn|  sets5|   setsShowOn|
      //                                                                                                  zoomOff  sets3    setsShowOff
      if (parts.length >= 17) {
        if (engine.showTime) {
          newParts.add(parts[0]);
        }
        if (engine.showKeeper) {
          newParts.add(parts[1]);
        }
        if (engine.showColors) {
          newParts.add(parts[2]);
          newParts.add(parts[3]);
          newParts.add(parts[4]);
          newParts.add(parts[5]);
        }
        if (engine.showNames) {
          newParts.add(parts[6]);
          newParts.add(parts[7]);
        }
        if (engine.showSets) {
          newParts.add(parts[8]);
          newParts.add(parts[9]);
        }
        if (engine.showScores) {
          newParts.add(parts[10]);
          newParts.add(parts[11]);
        }
        if (engine.showPossession) {
          newParts.add(parts[12]);
        }
        if (engine.showLookParams) {
          newParts.add(parts[13]);
          newParts.add(parts[14]);
          newParts.add(parts[15]);
          newParts.add(parts[16]);
        }
      }
      // time keeper comment
      // 0    1      2
      if (parts.length == 3) {
        if (engine.showTime) {
          newParts.add(parts[0]);
        }
        if (engine.showKeeper) {
          newParts.add(parts[1]);
        }
        if (engine.showComment) {
          newParts.add(parts[2]);
        }
      }
      result = ListTile(title: Center(child: Text(newParts.join(", "))));
    }

    // DRAWN
    if (!engine.showRaw) {
      List<String> parts = item.split(",");

      Color colorTextLeft = Colors.black;
      Color colorBackgroundLeft = Colors.white;
      Color colorTextRight = Colors.white;
      Color colorBackgroundRight = Colors.black;
      String timeLeft = "";
      String timeRight = "";
      String scoreLeft = "";
      String scoreRight = "";
      String nameLeft = "";
      String nameRight = "";
      String setsLeft = "";
      String setsRight = "";
      String posessionLeft = "";
      String posessionRight = "";
      String comment = "";

      // time keeper colorA1 colorA2 colorB1 colorB2 nameA nameB setsA setsB scoreA scoreB possesion font zoom     sets5    setsShow
      // 0    1      2       3       4       5       6     7     8     9     10     11     12        13   14       15       16
      //                                                                                   1|2       str  zoomOn|  sets5|   setsShowOn|
      //                                                                                                  zoomOff  sets3    setsShowOff
      if (parts.length >= 17) {
        if (engine.showTime) {
          timeLeft = parts[0];
          // convert to local time
          timeLeft = timeLeft.replaceAll("_", "T");
          var ts = DateTime.parse(timeLeft);
          timeLeft = ts.toLocal().toString();
          timeLeft = timeLeft.replaceAll("T", "_");
          timeLeft = timeLeft.replaceAll(".000", "");
        }
        if (engine.showKeeper) {
          timeRight = parts[1];
        }
        if (engine.showColors) {
          colorTextLeft = Color(engine.parseReflectorHex(parts[2]));
          colorBackgroundLeft = Color(engine.parseReflectorHex(parts[3]));
          colorTextRight = Color(engine.parseReflectorHex(parts[4]));
          colorBackgroundRight = Color(engine.parseReflectorHex(parts[5]));
        }
        if (engine.showNames) {
          nameLeft = parts[6];
          nameRight = parts[7];
        }
        if (engine.showSets) {
          var tempLeft = engine.parseReflectorInt(parts[8]);
          var tempRight = engine.parseReflectorInt(parts[9]);
          while (tempLeft > 0) {
            setsLeft += ". ";
            tempLeft--;
          }
          while (tempRight > 0) {
            setsRight += ". ";
            tempRight--;
          }
        }
        if (engine.showScores) {
          scoreLeft = parts[10];
          scoreRight = parts[11];
        }
        if (engine.showPossession) {
          // newParts.add(parts[12]);
          var temp = engine.parseReflectorInt(parts[12]);
          if (temp == 1) {
            posessionLeft = " > ";
          }
          if (temp == 2) {
            posessionRight = " < ";
          }
        }
        //if (engine.showLookParams) {
        engine.fontType = engine.stringToFont(parts[13]);
        engine.zoom = (parts[14] == "zoomOn");
        engine.sets5 = (parts[15] == "sets5");
        engine.showSets = (parts[16] == "setsShowOn");
        //}
      }
      // time keeper comment
      // 0    1      2
      if (parts.length == 3) {
        if (engine.showTime) {
          timeLeft = parts[0];
        }
        if (engine.showKeeper) {
          timeRight = parts[1];
        }
        if (engine.showComment) {
          comment = parts[2];
        }
        timeLeft = timeLeft + " " + timeRight;
      }
      Widget boxLeft = SizedBox.shrink();
      Widget boxRight = SizedBox.shrink();
      //print(comment.length);
      if (comment.isNotEmpty) {
        var height = (comment.length / 45) * 80.0;

        // look for url links
        var url = "";
        if (comment.contains("https://")) {
          comment += " ";
          int start = comment.indexOf("https://");
          int end = comment.indexOf(" ", start);
          url = comment.substring(start, end);
        }

        boxLeft = SizedBox(
          width: 300.0,
          height: height,
          child: GestureDetector(
            child: Column(
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: colorBackgroundLeft,
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new Text(
                        comment,
                        style: kLabelTextStyle_system.copyWith(
                            color: colorTextLeft, fontSize: 20),
                      ),
                    ),
                  ),
                ),
                new Text(
                  timeLeft,
                  style: kLabelTextStyle_system.copyWith(
                      color: colorTextLeft, fontSize: 15),
                ),
              ],
            ),
            onDoubleTap: () {
              // allow double tap for url if available
              if (url.isNotEmpty) {
                _launchUrl(url);
              }
            },
          ),
        );
      }
      if (comment.isEmpty) {
        boxLeft = SizedBox(
          width: 150.0,
          height: 90.0,
          child: Column(
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: colorBackgroundLeft,
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
                child: Center(
                    child: Row(
                  children: [
                    SizedBox(width: 4),
                    Container(
                      constraints: BoxConstraints(maxWidth: 50),
                      child: Column(
                        children: [
                          SizedBox(height: 10),
                          new Text(
                            posessionLeft + nameLeft,
                            style: kLabelTextStyle_system.copyWith(
                                color: colorTextLeft, fontSize: 10),
                            overflow: TextOverflow.clip,
                            softWrap: false,
                          ),
                          new Text(
                            setsLeft,
                            style: kLabelTextStyle_system.copyWith(
                                color: colorTextLeft, fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 20),
                    new Text(
                      scoreLeft,
                      style:
                          kLabelTextStyle_system.copyWith(color: colorTextLeft),
                    ),
                    SizedBox(width: 4),
                  ],
                )),
              ),
              new Text(
                timeLeft,
                style: kLabelTextStyle_system.copyWith(
                    color: colorTextLeft, fontSize: 15),
              ),
            ],
          ),
        );

        boxRight = SizedBox(
          width: 150.0,
          height: 90.0,
          child: Column(
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: colorBackgroundRight,
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
                child: Center(
                    child: Row(
                  children: [
                    SizedBox(width: 4),
                    new Text(
                      scoreRight,
                      style: kLabelTextStyle_system.copyWith(
                          color: colorTextRight),
                    ),
                    SizedBox(width: 20),
                    Container(
                      constraints: BoxConstraints(maxWidth: 50),
                      child: Column(
                        children: [
                          SizedBox(height: 10),
                          new Text(
                            posessionRight + nameRight,
                            style: kLabelTextStyle_system.copyWith(
                                color: colorTextRight, fontSize: 10),
                            overflow: TextOverflow.clip,
                            softWrap: false,
                          ),
                          new Text(
                            setsRight,
                            style: kLabelTextStyle_system.copyWith(
                                color: colorTextRight, fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 20),
                  ],
                )),
              ),
              new Text(
                timeRight,
                style: kLabelTextStyle_system.copyWith(
                    color: colorTextLeft, fontSize: 15),
              ),
            ],
          ),
        );
      }

      Widget centerBox = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          boxLeft,
          SizedBox(width: 10),
          boxRight,
        ],
      );
      result = ListTile(
        //minVerticalPadding: 20.0,
        title: Center(child: centerBox),
      );
    }

    ListTile(title: Center(child: Text(item)));
    return result;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kSettingsModalBackgroundColor,
      body: ListView.builder(
        controller: controller,
        padding: const EdgeInsets.all(8),
        itemCount: items.length + 1,
        itemBuilder: (context, index) {
          if (index < items.length) {
            final item = items[index];
            return _buildListTile(item);
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Center(
                child: hasMore
                    ? const Center(child: CircularProgressIndicator())
                    : const Text("no more scores"),
              ),
            );
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingButtons(
        screenHeight: screenHeight,
        screenWidth: screenWidth,
        engine: engine,
        onRefreshFromReflector: _refreshReflector,
        onSavePending: _savePending,
        onSaveReflector: _saveReflector,
      ),
    );
  }
}
