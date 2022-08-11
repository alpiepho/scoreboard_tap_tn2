import 'package:flutter/material.dart';
import '../components/refresh_button.dart';
import '../components/settings_button.dart';
import '../components/settings_modal.dart';
import '../engine.dart';

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
    return Stack(
      fit: StackFit.expand,
      children: [
        // Positioned(
        //   left: 30,
        //   bottom: (screenHeight / 2) - 200,
        //   child: SizedBox(
        //     height: 500,
        //     width: 40,
        //     child: FloatingActionButton(
        //       heroTag: 'back',
        //       onPressed: onPreviousItem as Function()?,
        //       child: const Icon(
        //         Icons.arrow_left,
        //         size: 40,
        //         color: Color(0x55ffffff),
        //       ),
        //       shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(10),
        //       ),
        //       backgroundColor: const Color(0x00000000),
        //       foregroundColor: const Color(0x00000000),
        //       focusColor: const Color(0x00000000),
        //       hoverColor: const Color(0x11000000),
        //       splashColor: const Color(0x00000000),
        //       elevation: (allowHideButtons ? 0.0 : 6.0),
        //     ),
        //   ),
        // ),
        // Positioned(
        //   bottom: (screenHeight / 2) - 200,
        //   right: 30,
        //   child: SizedBox(
        //     height: 500,
        //     width: 40,
        //     child: FloatingActionButton(
        //       heroTag: 'next',
        //       onPressed: onNextItem as Function()?,
        //       child: const Icon(
        //         Icons.arrow_right,
        //         size: 40,
        //         color: Color(0x40ffffff),
        //       ),
        //       shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(10),
        //       ),
        //       backgroundColor: const Color(0x00000000),
        //       foregroundColor: const Color(0x00000000),
        //       focusColor: const Color(0x00000000),
        //       hoverColor: const Color(0x11000000),
        //       splashColor: const Color(0x00000000),
        //       elevation: (allowHideButtons ? 0.0 : 6.0),
        //     ),
        //   ),
        // ),
        // Positioned(
        //   bottom: 20,
        //   right: (screenWidth / 4),
        //   child: SizedBox(
        //     height: 50,
        //     width: screenWidth / 2,
        //     child: FloatingActionButton(
        //       heroTag: 'pause',
        //       onPressed: onTogglePause as Function()?,
        //       child: Icon(
        //         (paused ? Icons.play_arrow : Icons.pause),
        //         size: 40,
        //         color: const Color(0x30ffffff),
        //       ),
        //       shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(10),
        //       ),
        //       backgroundColor: const Color(0x00000000),
        //       foregroundColor: const Color(0x00000000),
        //       focusColor: const Color(0x00000000),
        //       hoverColor: const Color(0x11000000),
        //       splashColor: const Color(0x00000000),
        //       elevation: (allowHideButtons ? 0.0 : 6.0),
        //     ),
        //   ),
        // ),
        Positioned(
          top: 50,
          right: 30,
          child: RefreshButton(onPress: onRefreshFromReflector),
        ),
        Positioned(
          bottom: 20,
          right: 30,
          child: SettingsButton(onPress: () {
            // this._engine.setPending();
            showModalBottomSheet(
              context: context,
              builder: (BuildContext bc) {
                return SettingsModal(
                  context,
                  this.engine,
                  // _resetBoth,
                  // _clearBoth,
                  // _swapTeams,
                  onSavePending as Function,
                  onSaveReflector as Function,
                  // _saveComment,
                );
              },
              isScrollControlled: true,
            );
          }),
        ),
      ],
    );
  }
}
