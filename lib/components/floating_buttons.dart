import 'package:flutter/material.dart';
import '../components/refresh_button.dart';
import '../components/settings_button.dart';
import '../components/settings_modal.dart';
import '../engine.dart';
import 'scores_button.dart';
import 'stream_button.dart';
import 'stream_modal.dart';

class FloatingButtons extends StatelessWidget {
  const FloatingButtons({
    Key? key,
    required this.screenHeight,
    required this.screenWidth,
    required this.engine,
    required this.onRefreshFromReflector,
    required this.onSavePending,
    required this.onSaveReflector,
  }) : super(key: key);

  final double screenHeight;
  final double screenWidth;
  final Engine engine;
  final Function? onRefreshFromReflector;
  final Function? onSavePending;
  final Function? onSaveReflector;

  @override
  Widget build(BuildContext context) {
    Widget scoresStreamButton;
    Widget settingsButton;
    if (engine.streamsMode) {
      scoresStreamButton = ScoresButton(onPress: () {
        // TODO does this work?
        Navigator.of(context).pop();
        engine.streamsMode = false;
      });
      settingsButton = SizedBox.shrink();
    } else {
      scoresStreamButton = StreamButton(onPress: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext bc) {
            return StreamModal(
              context,
              this.engine,
              onSavePending as Function,
              onSaveReflector as Function,
            );
          },
          isScrollControlled: true,
        );
        engine.streamsMode = true;
      });
      settingsButton = SettingsButton(onPress: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext bc) {
            return SettingsModal(
              context,
              this.engine,
              onSavePending as Function,
              onSaveReflector as Function,
            );
          },
          isScrollControlled: true,
        );
      });
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned(
          top: 50,
          right: 30,
          child: RefreshButton(onPress: onRefreshFromReflector),
        ),
        Positioned(
          top: 120,
          right: 30,
          child: scoresStreamButton,
        ),
        Positioned(
          bottom: 20,
          right: 30,
          child: settingsButton,
        ),
      ],
    );
  }
}
