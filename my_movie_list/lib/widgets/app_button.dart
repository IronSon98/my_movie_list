import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AppButton extends StatelessWidget {
  String text;
  Function onPressed;

  AppButton(this.text, {this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      width: 230,
      child: RaisedButton(
        color: Colors.blueGrey[800],
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        onPressed: onPressed,
      ),
    );
  }
}
