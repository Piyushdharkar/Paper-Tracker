import 'package:flutter/material.dart';
import 'package:papertracker/config/constants.dart';

class HeaderText extends StatelessWidget {
  HeaderText({this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: kCardHeaderTextStyle,
    );
  }
}
