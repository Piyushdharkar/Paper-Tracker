import 'package:flutter/material.dart';
import 'package:papertracker/widgets/drop_down_stream.dart';
import 'package:papertracker/widgets/header_text.dart';

class FormCard<T> extends StatelessWidget {
  FormCard(
      {@required this.stream,
      this.headerText,
      @required this.currentValue,
      @required this.fieldName,
      this.field2Name,
      this.onChangeCallback});

  final stream;
  final String headerText;
  final T currentValue;
  final String fieldName;
  final String field2Name;
  final Function onChangeCallback;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderText(text: headerText ?? ''),
            SizedBox(
              height: 10.0,
            ),
            DropDownStream(
              stream,
              currentValue: currentValue,
              fieldName: fieldName,
              field2Name: field2Name,
              onChangeCallback: (value, name) {
                onChangeCallback(value, name);
              },
            ),
          ],
        ),
      ),
    );
  }
}
