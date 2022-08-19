import 'package:flutter/material.dart';

class ScoresButton extends StatelessWidget {
  ScoresButton({this.onPress});

  final Function? onPress;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      child: FloatingActionButton(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        onPressed: onPress as void Function()?,
        tooltip: 'Scores',
        child: Icon(Icons.looks_3_outlined, size: 50),
      ),
    );
  }
}
