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

  String scoreKeeper = "";
  String reflectorSite = "";
  String reflectorComment = "";

  late List<String> list = [];

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
    notify7Enabled = parts[index++] == "true";
    notify8Enabled = parts[index++] == "true";

    lastPointLeft = parts[index++] == "true";
    lastPointEnabled = parts[index++] == "true";

    // new since last release so check index
    if (index < parts.length) zoom = parts[index++] == "true";
    if (index < parts.length) setsShow = parts[index++] == "true";
    if (index < parts.length) sets5 = parts[index++] == "true";
    if (index < parts.length) setsLeft = int.parse(parts[index++]);
    if (index < parts.length) setsRight = int.parse(parts[index++]);

    if (index < parts.length) scoreKeeper = parts[index++];
    if (index < parts.length) reflectorSite = parts[index++];

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

  String parseLastRefelector() {
    int temp = 0;
    String result = "";
    // ie. timestamp,shannon,000000,ffffff,ffffff,000000,Them,Us,0,0, 10, 8,  0
    //     0         1       2      3      4      5      6    7  8 9  10  11  12
    // ie. timestamp,shannon,Them,Us,0,0,10, 8,0
    //     0         1       2    3  4 5 6   7 8
    // ie. timepstamp,shannon,{comment}
    //     0         1        2
    if (list.length > 0) {
      List<String> parts = list.last.split(",");

      if (parts.length == 13) {
        // workaround for back colors, need to debug
        temp = parseReflectorHex(parts[2]);
        if ((temp & 0xff000000) == 0) {
          print("BAD colors!!!");
          print(list.last);
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
    }
    return result;
  }

  void listClear() {
    list.clear();
  }

  void listAdd(String reflectorEvent) {
    print(reflectorEvent);
    if (reflectorEvent.isNotEmpty) {
      if (list.length > 1000) {
        list.removeAt(0);
      }
      list.add(reflectorEvent);
    }
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

  // void incrementLeft() {
  //   valueLeft += 1;
  //   lastPointLeft = true;
  // }

  // void decrementLeft() {
  //   valueLeft -= 1;
  //   if (valueLeft < 0) valueLeft = 0;
  // }

  // void incrementRight() {
  //   valueRight += 1;
  //   lastPointLeft = false;
  // }

  // void decrementRight() {
  //   valueRight -= 1;
  //   if (valueRight < 0) valueRight = 0;
  // }

  // void clearBoth() {
  //   valueLeft = 0;
  //   valueRight = 0;
  //   lastPointLeft = false;
  // }

  // void resetBoth() {
  //   labelLeft = "Away";
  //   labelRight = "Home";
  //   valueLeft = 0;
  //   valueRight = 0;
  //   lastPointLeft = false;
  //   colorTextLeft = Colors.black;
  //   colorBackgroundLeft = Colors.red;
  //   colorTextRight = Colors.black;
  //   colorBackgroundRight = Colors.blueAccent;
  //   // pendingColorTextLeft = colorTextLeft;
  //   // pendingColorBackgroundLeft = colorBackgroundLeft;
  //   // pendingColorTextRight = colorTextRight;
  //   // pendingColorBackgroundRight = colorBackgroundRight;
  //   fontType = FontTypes.system;
  //   setsLeft = 0;
  //   setsRight = 0;
  // }

  // void swapTeams() {
  //   var valueTemp = valueLeft;
  //   valueLeft = valueRight;
  //   valueRight = valueTemp;
  //   lastPointLeft = !lastPointLeft;

  //   var labelTemp = labelLeft;
  //   labelLeft = labelRight;
  //   labelRight = labelTemp;

  //   var colorTemp = colorTextLeft;
  //   colorTextLeft = colorTextRight;
  //   colorTextRight = colorTemp;

  //   colorTemp = colorBackgroundLeft;
  //   colorBackgroundLeft = colorBackgroundRight;
  //   colorBackgroundRight = colorTemp;

  //   var setsTemp = setsLeft;
  //   setsLeft = setsRight;
  //   setsRight = setsTemp;
  // }

  // void savePending() {
  //   labelLeft = pendingLabelLeft;
  //   labelRight = pendingLabelRight;
  //   colorTextLeft = pendingColorTextLeft;
  //   colorBackgroundLeft = pendingColorBackgroundLeft;
  //   colorTextRight = pendingColorTextRight;
  //   colorBackgroundRight = pendingColorBackgroundRight;
  // }

  void setPending() {
    // pendingLabelLeft = labelLeft;
    // pendingLabelRight = labelRight;
    // pendingColorTextLeft = colorTextLeft;
    // pendingColorBackgroundLeft = pendingColorBackgroundLeft;
    // pendingColorBackgroundRight = pendingColorBackgroundRight;
  }

  // bool notify7() {
  //   if (notify7Enabled) {
  //     if (((valueLeft + valueRight) % 7) == 0) return true;
  //   }
  //   return false;
  // }

  // bool notify8() {
  //   if (notify8Enabled) {
  //     if (valueLeft == 8 || valueRight == 8) return true;
  //   }
  //   return false;
  // }
}
