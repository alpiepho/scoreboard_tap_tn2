import 'package:flutter/material.dart';

class StreamButton extends StatelessWidget {
  StreamButton({this.onPress});

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
        tooltip: 'Stream',
        child: Icon(Icons.sort, size: 50),
      ),
    );
  }
}
