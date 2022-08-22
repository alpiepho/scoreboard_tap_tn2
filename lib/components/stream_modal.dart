import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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

  Future fetchKeepers() async {
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
      engine.possibleKeeper = names.join(",");
    }
  }

  Future fetchAll(int offset, int count) async {
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
    print(url);

    try {
      http.Response response = await http.get(url);
      print(response.body);
      final data = jsonDecode(response.body);
      print(data);

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

  Future fetch() async {
    if (isLoading) return;
    isLoading = true;

    await fetchKeepers();
    await fetchAll(itemIndex, perPage);
    itemIndex += perPage;
    isLoading = false;
  }

  @override
  void initState() {
    super.initState();

    fetch();

    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        fetch();
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _refreshReflector() async {
    items = [];
    itemIndex = 0;
    fetch();
    Navigator.of(context).pop();
  }

  void _savePending() async {
    // TODO: may need these
    // _fromEngine();
    // _saveEngine();
    Navigator.of(context).pop();
  }

  void _saveReflector() async {
    // _fromEngine();
    // _saveEngine();
    Navigator.of(context).pop();
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
            return ListTile(title: Center(child: Text(item)));
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
