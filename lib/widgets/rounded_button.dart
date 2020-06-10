import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  RoundButton({this.text, this.onPressedCallback});

  final String text;
  final Function onPressedCallback;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10.0,
      color: Colors.lightBlue,
      child: FlatButton(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        onPressed: () {
          onPressedCallback();
        },
      ),
    );
  }
}
