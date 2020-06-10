import 'package:flutter/material.dart';
import 'package:papertracker/widgets/header_text.dart';

class FormCard<T> extends StatelessWidget {
  FormCard({this.headerText, this.child});

  final String headerText;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderText(text: headerText ?? ''),
            SizedBox(
              height: 10.0,
            ),
            child,
          ],
        ),
      ),
    );
  }
}
