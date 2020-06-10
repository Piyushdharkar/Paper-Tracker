import 'package:flutter/material.dart';

class Track {
  Track(
      {@required this.no,
      @required this.name,
      this.currentPaper,
      this.nextPaper});

  int no;
  String name;
  String currentPaper;
  String nextPaper;

  @override
  bool operator ==(other) {
    return other is Track && no == other.no;
  }
}
