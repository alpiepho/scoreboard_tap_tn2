import 'package:flutter/material.dart';

class FloatingButtons extends StatelessWidget {
  const FloatingButtons({
    Key? key,
    required this.screenHeight,
    required this.screenWidth,
    required this.paused,
    required this.allowHideButtons,
    required this.onPreviousItem,
    required this.onNextItem,
    required this.onTogglePause,
    required this.onHelp,
  }) : super(key: key);

  final double screenHeight;
  final double screenWidth;
  final bool paused;
  final bool allowHideButtons;
  final Function? onPreviousItem;
  final Function? onNextItem;
  final Function? onTogglePause;
  final Function? onHelp;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned(
          left: 30,
          bottom: (screenHeight / 2) - 200,
          child: SizedBox(
            height: 500,
            width: 40,
            child: FloatingActionButton(
              heroTag: 'back',
              onPressed: onPreviousItem as Function()?,
              child: const Icon(
                Icons.arrow_left,
                size: 40,
                color: Color(0x55ffffff),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: const Color(0x00000000),
              foregroundColor: const Color(0x00000000),
              focusColor: const Color(0x00000000),
              hoverColor: const Color(0x11000000),
              splashColor: const Color(0x00000000),
              elevation: (allowHideButtons ? 0.0 : 6.0),
            ),
          ),
        ),
        Positioned(
          bottom: (screenHeight / 2) - 200,
          right: 30,
          child: SizedBox(
            height: 500,
            width: 40,
            child: FloatingActionButton(
              heroTag: 'next',
              onPressed: onNextItem as Function()?,
              child: const Icon(
                Icons.arrow_right,
                size: 40,
                color: Color(0x40ffffff),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: const Color(0x00000000),
              foregroundColor: const Color(0x00000000),
              focusColor: const Color(0x00000000),
              hoverColor: const Color(0x11000000),
              splashColor: const Color(0x00000000),
              elevation: (allowHideButtons ? 0.0 : 6.0),
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          right: (screenWidth / 4),
          child: SizedBox(
            height: 50,
            width: screenWidth / 2,
            child: FloatingActionButton(
              heroTag: 'pause',
              onPressed: onTogglePause as Function()?,
              child: Icon(
                (paused ? Icons.play_arrow : Icons.pause),
                size: 40,
                color: const Color(0x30ffffff),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: const Color(0x00000000),
              foregroundColor: const Color(0x00000000),
              focusColor: const Color(0x00000000),
              hoverColor: const Color(0x11000000),
              splashColor: const Color(0x00000000),
              elevation: (allowHideButtons ? 0.0 : 6.0),
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          right: 30,
          child: FloatingActionButton(
            heroTag: 'settings',
            onPressed: onHelp as Function()?,
            child: const Icon(
              Icons.settings,
              size: 40,
            ),
          ),
        ),
      ],
    );
  }
}
