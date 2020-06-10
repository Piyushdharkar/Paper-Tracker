import 'package:flutter/material.dart';
import 'package:papertracker/screens/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(
        textTheme: TextTheme(
          subtitle1: TextStyle(
            color: Colors.black,
            fontFamily: 'Raleway',
          ),
          bodyText2: TextStyle(
            color: Colors.black,
            fontFamily: 'Raleway',
          ),
          button: TextStyle(
            color: Colors.black,
            fontFamily: 'Raleway',
          ),
        ),
      ),
      home: HomePage(),
    );
  }
}
