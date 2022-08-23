// import 'dart:html';

import 'package:flutter/material.dart';
import '../constants.dart';

class Engine {
  Color colorTextLeft = Colors.black;
  Color colorBackgroundLeft = Colors.red;
  Color colorTextRight = Colors.black;
  Color colorBackgroundRight = Colors.blueAccent;

  String labelLeft = "Away";
  String labelRight = "Home";
  int valueLeft = 0;
  int valueRight = 0;

  // String pendingLabelLeft = "";
  // String pendingLabelRight = "";
  // Color pendingColorTextLeft = Colors.black;
  // Color pendingColorBackgroundLeft = Colors.red;
  // Color pendingColorTextRight = Colors.black;
  // Color pendingColorBackgroundRight = Colors.blueAccent;

  FontTypes fontType = FontTypes.system;

  bool notify7Enabled = false;
  bool notify8Enabled = false;
  bool lastPointLeft = false;
  bool lastPointEnabled = true;
  bool zoom = false;
  // bool setsShow = false;
  // bool sets5 = false;
  bool setsShow = true;
  bool sets5 = true;
  int setsLeft = 0;
  int setsRight = 0;

  bool streamsMode = false;

  // TODO: remove DEBUG
  String scoreKeeper = "keeper1";
  String reflectorSite = "http://localhost:3000";
  // String scoreKeeper = ""; // can be comma separated list or *
  // String reflectorSite = "https://refelectortn2.uw.r.appspot.com";

  // raw (w/ time, keeper, colors, names, sets, possession):
  //   2022-08-22_05:54:34,keeper1,ff000000,fff44336,ff000000,ff448aff,Away1,Home1,0,0,24,18,1
  // raw (w/ time, keeper, names, sets, possession):
  //   2022-08-22_05:54:34,keeper1,Away1,Home1,0,0,24,18,1
  // raw (w/ time, names):
  //   2022-08-22_05:54:34,Away1,Home1,24,18

  // !raw:
  //  bubbles:  Away1 (with colors)       Home1 (with colors)
  //  bubbles:  24 (with colors)          18 (with colors)
  //            1                         0
  //            2022-08-22_05:54:34 (small text under bubble)
  //  ...
  //  comment: bubble across, centered

  bool showTime = true;
  bool showKeeper = true;
  bool showColors = true;
  bool showNames = true;
  bool showSets = true;
  bool showScores = true;
  bool showPossession = true;
  bool showComment = true;
  bool showRaw = true;

  // not saved
  String reflectorComment = "";
  String possibleKeeper = "unknown";

  Engine();

  //
  // pack/unpack
  //
  String pack() {
    String result = "";

    result += colorTextLeft.toString() + ";";
    result += colorBackgroundLeft.toString() + ";";
    result += colorTextRight.toString() + ";";
    result += colorBackgroundRight.toString() + ";";

    result += labelLeft.toString() + ";";
    result += labelRight.toString() + ";";
    result += valueLeft.toString() + ";";
    result += valueRight.toString() + ";";

    result += "removed" + ";";
    result += "removed" + ";";
    result += "removed" + ";";
    result += "removed" + ";";

    result += fontType.toString() + ";";

    result += "removed" + ";"; // was forceLandscape
    result += notify7Enabled.toString() + ";";
    result += notify8Enabled.toString() + ";";

    result += lastPointLeft.toString() + ";";
    result += lastPointEnabled.toString() + ";";

    result += zoom.toString() + ";";
    result += setsShow.toString() + ";";
    result += sets5.toString() + ";";
    result += setsLeft.toString() + ";";
    result += setsRight.toString() + ";";

    result += scoreKeeper.toString() + ";";
    result += reflectorSite.toString() + ";";

    result += showTime.toString() + ";";
    result += showKeeper.toString() + ";";
    result += showColors.toString() + ";";
    result += showNames.toString() + ";";
    result += showSets.toString() + ";";
    result += showScores.toString() + ";";
    result += showPossession.toString() + ";";
    result += showComment.toString() + ";";
    result += showRaw.toString() + ";";

    return result;
  }

  Color stringToColor(String code) {
    // .... Color(0xff000000)
    var parts = code.split("0x");
    var s = parts[1].substring(0, 8);
    var h = int.parse(s, radix: 16);
    return new Color(h);
  }

  void unpack(String packed) {
    if (packed.length == 0) return;

    var parts = packed.split(";");
    int index = 0;

    colorTextLeft = stringToColor(parts[index++]);
    colorBackgroundLeft = stringToColor(parts[index++]);
    colorTextRight = stringToColor(parts[index++]);
    colorBackgroundRight = stringToColor(parts[index++]);

    labelLeft = parts[index++];
    labelRight = parts[index++];
    valueLeft = int.parse(parts[index++]);
    valueRight = int.parse(parts[index++]);

    index++;
    index++;
    index++;
    index++;

    fontType = FontTypes.system;
    for (var value in FontTypes.values) {
      if (value.toString() == parts[index]) {
        fontType = value;
        break;
      }
    }
    index++;

    index++; // was forceLandscape
    if (index < parts.length) notify7Enabled = parts[index++] == "true";
    if (index < parts.length) notify8Enabled = parts[index++] == "true";

    if (index < parts.length) lastPointLeft = parts[index++] == "true";
    if (index < parts.length) lastPointEnabled = parts[index++] == "true";

    // new since last release so check index
    if (index < parts.length) zoom = parts[index++] == "true";
    if (index < parts.length) setsShow = parts[index++] == "true";
    if (index < parts.length) sets5 = parts[index++] == "true";
    if (index < parts.length) setsLeft = int.parse(parts[index++]);
    if (index < parts.length) setsRight = int.parse(parts[index++]);

    if (index < parts.length) scoreKeeper = parts[index++];
    if (index < parts.length) reflectorSite = parts[index++];

    if (index < parts.length) showTime = parts[index++] == "true";
    if (index < parts.length) showKeeper = parts[index++] == "true";
    if (index < parts.length) showColors = parts[index++] == "true";
    if (index < parts.length) showNames = parts[index++] == "true";
    if (index < parts.length) showSets = parts[index++] == "true";
    if (index < parts.length) showScores = parts[index++] == "true";
    if (index < parts.length) showPossession = parts[index++] == "true";
    if (index < parts.length) showComment = parts[index++] == "true";
    if (index < parts.length) showRaw = parts[index++] == "true";

    colorTextLeft = colorTextLeft;
    colorBackgroundLeft = colorBackgroundLeft;
    colorTextRight = colorTextRight;
    colorBackgroundRight = colorBackgroundRight;

    // pendingColorTextLeft = colorTextLeft;
    // pendingColorBackgroundLeft = colorBackgroundLeft;
    // pendingColorTextRight = colorTextRight;
    // pendingColorBackgroundRight = colorBackgroundRight;
  }

  //
  // Public methods
  //

  int parseReflectorHex(String part) {
    int result = int.parse(part, radix: 16);
    return result;
  }

  int parseReflectorInt(String part) {
    int result = int.parse(part, radix: 10);
    return result;
  }

  String parseLastRefelector(String last) {
    if (last.isEmpty) {
      return "";
    }

    int temp = 0;
    String result = "";
    // ie. timestamp,shannon,000000,ffffff,ffffff,000000,Them,Us,0,0, 10, 8,  0
    //     0         1       2      3      4      5      6    7  8 9  10  11  12
    // ie. timestamp,shannon,Them,Us,0,0,10, 8,0
    //     0         1       2    3  4 5 6   7 8
    // ie. timepstamp,shannon,{comment}
    //     0         1        2
    List<String> parts = last.split(",");

    if (parts.length == 13) {
      // workaround for back colors, need to debug
      temp = parseReflectorHex(parts[2]);
      if ((temp & 0xff000000) == 0) {
        print("BAD colors!!!");
        print(last);
      } else {
        colorTextLeft = Color(parseReflectorHex(parts[2]));
        colorBackgroundLeft = Color(parseReflectorHex(parts[3]));
        colorTextRight = Color(parseReflectorHex(parts[4]));
        colorBackgroundRight = Color(parseReflectorHex(parts[5]));
      }

      labelLeft = parts[6];
      labelRight = parts[7];

      setsLeft = parseReflectorInt(parts[8]);
      setsRight = parseReflectorInt(parts[9]);

      valueLeft = parseReflectorInt(parts[10]);
      valueRight = parseReflectorInt(parts[11]);

      lastPointLeft = parseReflectorInt(parts[12]) == 1;
    }
    if (parts.length == 9) {
      labelLeft = parts[2];
      labelRight = parts[3];

      setsLeft = parseReflectorInt(parts[4]);
      setsRight = parseReflectorInt(parts[5]);

      valueLeft = parseReflectorInt(parts[6]);
      valueRight = parseReflectorInt(parts[7]);

      lastPointLeft = parseReflectorInt(parts[8]) == 1;
    }
    if (parts.length == 3) {
      result = parts[2];
    }

    return result;
  }

  String getLabelLeft() {
    String result = labelLeft;
    if (lastPointEnabled) {
      if ((valueLeft > 0 || valueRight > 0) && lastPointLeft) {
        result = labelLeft + " >";
      }
    }
    return result;
  }

  String getLabelRight() {
    String result = labelRight;
    if (lastPointEnabled) {
      if ((valueLeft > 0 || valueRight > 0) && !lastPointLeft) {
        result = "< " + labelRight;
      }
    }
    return result;
  }
}
