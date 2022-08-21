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

  Future fetch() async {
    if (isLoading) return;
    isLoading = true;

    setState(() {
      // TODO: replace this with call to refelector
      List<String> newItems = List.generate(
        perPage,
        (index) => 'Item ${index + itemIndex + 1}',
      );
      items.addAll(newItems);
      itemIndex += perPage;
      if (items.length > 100) {
        hasMore = false;
      }
    });
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

// TODO tie in with fetch
// TODO only get a page???
  void _refreshReflector() async {
    if (engine.reflectorSite.isEmpty || engine.scoreKeeper.isEmpty) {
      return;
    }

    // TODO get for list of keepers or all???

    List<String> reflectorKeepers = [];
    String urlString = "";
    String encoded;
    Uri _url;

    // prove keepers
    urlString = engine.reflectorSite;
    urlString += "/keepers/json";

    encoded = Uri.encodeFull(urlString);
    _url = Uri.parse(encoded);

    try {
      http.Response response = await http.get(_url);
      final data = jsonDecode(response.body);
      for (int i = 0; i < data['keepers'].length; i++) {
        print(data['keepers'][i]);
        reflectorKeepers.add(data['keepers'][i]);
      }
    } catch (exception, message) {
      print(exception);
      print(message);
    }

    // prove keepers page
    String currentKeeper = reflectorKeepers[0];
    urlString = engine.reflectorSite;
    urlString += "/";
    urlString += currentKeeper;
    urlString += "/json";
    urlString += "?offset=1&count=2";

    encoded = Uri.encodeFull(urlString);
    _url = Uri.parse(encoded);
    print(_url);

    try {
      http.Response response = await http.get(_url);
      print(response.body);
      final data = jsonDecode(response.body);
      print(data);
      for (int i = 0; i < data[currentKeeper].length; i++) {
        print(data[currentKeeper][i]);
        //this.engine.listAdd(events[i]);
      }
    } catch (exception, message) {
      print(exception);
      print(message);
    }

    // prove all page
    urlString = engine.reflectorSite;
    urlString += "/json";
    urlString += "?offset=0&count=15";

    encoded = Uri.encodeFull(urlString);
    _url = Uri.parse(encoded);
    print(_url);

    try {
      http.Response response = await http.get(_url);
      print(response.body);
      final data = jsonDecode(response.body);
      print(data);
      for (int i = 0; i < data['all'].length; i++) {
        print(data['all'][i]);
        //this.engine.listAdd(events[i]);
      }
    } catch (exception, message) {
      print(exception);
      print(message);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kSettingsModalBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.grey,
        foregroundColor: Colors.white,
        toolbarHeight: 50,
        titleSpacing: 20,
        title: Text(
          "Score Stream",
          style: kSettingsTextEditStyle,
        ),
      ),
      body: ListView.builder(
        controller: controller,
        padding: const EdgeInsets.all(8),
        itemCount: items.length + 1,
        itemBuilder: (context, index) {
          if (index < items.length) {
            final item = items[index];
            return ListTile(title: Text(item));
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
        onSavePending: () {},
        onSaveReflector: () {},
      ),
    );
  }
}
