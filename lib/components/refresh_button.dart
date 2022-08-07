import 'package:flutter/material.dart';

class RefreshButton extends StatelessWidget {
  RefreshButton({this.onPress});

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
        tooltip: 'Refresh',
        child: Icon(Icons.refresh, size: 50),
      ),
    );
  }
}
