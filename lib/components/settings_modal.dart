import 'package:flutter/material.dart';
import '../constants.dart';
import '../engine.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class SettingsModal extends StatefulWidget {
  late BuildContext context;
  late Engine engine;
  late Function onDone;
  late Function onReflector;

  SettingsModal(
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
  _SettingsModal createState() => _SettingsModal(
        context,
        engine,
        onDone,
        onReflector,
      );
}

class _SettingsModal extends State<SettingsModal> {
  _SettingsModal(
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

  void fontChanged(FontTypes fontType) async {
    this.engine.fontType = fontType;
    this.onDone();
    Navigator.of(context).pop();
  }

  void onFontChange() async {
    List<Widget> widgets = [];
    for (var value in FontTypes.values) {
      var style = getLabelFont(value);
      var tile = new ListTile(
        title: new Text(
          getFontString(value),
          style: style.copyWith(fontSize: kSettingsTextStyle_fontSize),
        ),
        onTap: () => fontChanged(value),
        trailing: new Icon(engine.fontType == value ? Icons.check : null),
      );
      widgets.add(tile);
    }

    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: kSettingsModalBackgroundColor,
          appBar: AppBar(
            backgroundColor: Colors.grey,
            foregroundColor: Colors.white,
            toolbarHeight: 50,
            titleSpacing: 20,
            title: Text("Settings"),
            actions: [],
          ),
          body: Container(
            child: ListView(
              children: widgets,
            ),
          ),
        );
      },
      isScrollControlled: true,
    );
  }

  void onZoomChanged() async {
    if (!this.engine.zoom) {
      this.engine.zoom = true;
    } else {
      this.engine.zoom = false;
    }
    this.onDone();
  }

  Future<void> _launchUrl(String urlString) async {
    Uri _url = Uri.parse(urlString);
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }

  void onReflectorSite() async {
    if (engine.reflectorSite.isNotEmpty) {
      String url = engine.reflectorSite + "/html";
      _launchUrl(url);
    }
    Navigator.of(context).pop();
  }

  void onReflectorSiteKeeper() async {
    if (engine.reflectorSite.isNotEmpty && engine.scoreKeeper.isNotEmpty) {
      var parts = engine.scoreKeeper.split(',');
      var scoreKeeper = parts[0]; // just first keeper from settings page/modal
      String url = engine.reflectorSite + "/" + scoreKeeper + "/html";
      _launchUrl(url);
    }
    Navigator.of(context).pop();
  }

  void onScoresQR() async {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Scores QR'),
          content: SingleChildScrollView(
            child: Container(
              width: 200,
              height: 200,
              child: Image.asset("assets/qr-code-scores.png"),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Done'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void onScoresTapQR() async {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Scores Tap QR'),
          content: SingleChildScrollView(
            child: Image.asset("assets/qr-code-tap.png"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Done'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void onScoresLink() async {
    _launchUrl('https://alpiepho.github.io/scoreboard_tn2/');
    Navigator.of(context).pop();
  }

  void onScoresTapLink() async {
    _launchUrl('https://alpiepho.github.io/scoreboard_tap_tn2/');
    Navigator.of(context).pop();
  }

  void onHelp() async {
    _launchUrl(
        'https://github.com/alpiepho/scoreboard_tap_tn2/blob/master/README.md');
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    var fontString = getFontString(engine.fontType);
    var fontStyle = getLabelFont(engine.fontType);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kSettingsModalBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.grey,
        foregroundColor: Colors.white,
        toolbarHeight: 50,
        titleSpacing: 20,
        title: Text(
          "Settings",
          style: kSettingsTextEditStyle,
        ),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Divider(),
            new ListTile(
              title: new Text(
                'Change Fonts...',
                style: kSettingsTextEditStyle,
              ),
              onTap: onFontChange,
            ),
            new ListTile(
              title: new Text(
                fontString,
                style:
                    fontStyle.copyWith(fontSize: kSettingsTextStyle_fontSize),
              ),
              onTap: onFontChange,
            ),
            new ListTile(
              title: new Text(
                'Zoom.',
                style: kSettingsTextEditStyle,
              ),
              trailing: new Icon(engine.zoom
                  ? Icons.check_box
                  : Icons.check_box_outline_blank),
              onTap: onZoomChanged,
            ),
            Divider(),
            Divider(),
            Divider(),
            Divider(),
            new ListTile(
              title: new Text(
                "Reflector Settings (blank to disable):",
                style: kSettingsTextEditStyle,
              ),
            ),
            new ListTile(
              title: new Text(
                "(available: " + engine.possibleKeeper + ")",
                style: kSettingsTextEditStyle,
              ),
            ),
            new ListTile(
              leading: null,
              title: new TextFormField(
                decoration:
                    new InputDecoration.collapsed(hintText: 'Scorekeeper Name'),
                autofocus: false,
                initialValue: engine.scoreKeeper,
                onChanged: (text) {
                  // can be comma separated list or *
                  engine.scoreKeeper = text.replaceAll(' ', ',');
                },
                style: kSettingsTextEditStyle,
              ),
              trailing: new Icon(Icons.edit),
            ),
            new ListTile(
              leading: null,
              title: new TextFormField(
                decoration:
                    new InputDecoration.collapsed(hintText: 'Reflector Site'),
                autofocus: false,
                initialValue: engine.reflectorSite,
                onChanged: (text) => engine.reflectorSite = text,
                style: kSettingsTextEditStyle,
              ),
              trailing: new Icon(Icons.edit),
            ),
            new ListTile(
              title: new Text(
                'Save Reflector Settings.',
                style: kSettingsTextEditStyle,
              ),
              //trailing: new Icon(Icons.done),
              onTap: onReflector as void Function()?,
            ),
            Divider(),
            Divider(),
            Divider(),
            Divider(),
            Divider(),
            new ListTile(
              title: new Text(
                'Reflector Site...',
                style: kSettingsTextEditStyle,
              ),
              trailing: new Icon(Icons.help),
              onTap: onReflectorSite,
            ),
            new ListTile(
              title: new Text(
                'Reflector Keeper...',
                style: kSettingsTextEditStyle,
              ),
              trailing: new Icon(Icons.help),
              onTap: onReflectorSiteKeeper,
            ),
            Divider(),
            Divider(),
            Divider(),
            Divider(),
            Divider(),
            new ListTile(
              title: new Text(
                kVersion,
                style: kSettingsTextEditStyle,
              ),
            ),
            new ListTile(
              title: new Text(
                'Scores QR...',
                style: kSettingsTextEditStyle,
              ),
              trailing: new Icon(Icons.help),
              onTap: onScoresQR,
            ),
            new ListTile(
              title: new Text(
                'Scores Tap QR...',
                style: kSettingsTextEditStyle,
              ),
              trailing: new Icon(Icons.help),
              onTap: onScoresTapQR,
            ),
            new ListTile(
              title: new Text(
                'Scores Link...',
                style: kSettingsTextEditStyle,
              ),
              trailing: new Icon(Icons.help),
              onTap: onScoresLink,
            ),
            new ListTile(
              title: new Text(
                'Scores Tap Link...',
                style: kSettingsTextEditStyle,
              ),
              trailing: new Icon(Icons.help),
              onTap: onScoresTapLink,
            ),
            new ListTile(
              title: new Text(
                'Help...',
                style: kSettingsTextEditStyle,
              ),
              trailing: new Icon(Icons.help),
              onTap: onHelp,
            ),
            Divider(),
            Divider(),
            Divider(),
            Divider(),
          ],
        ),
      ),
    );
  }
}
