import 'package:flutter/material.dart';

import 'custom_drop_down_row.dart';

class CustomDropDownStream<T, U> extends StatelessWidget {
  CustomDropDownStream(
    this.stream, {
    @required this.currentValue,
    @required this.fieldName,
    this.hintText,
    this.defaultText,
    this.noneValue,
    this.onChangeCallback,
  });

  final stream;
  final T currentValue;
  final String fieldName;
  final String hintText;
  final String defaultText;
  final T noneValue;
  final Function onChangeCallback;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final List<T> field1List = [];
        final items = snapshot.data.documents;
        for (var item in items) {
          T field1 = item.data[fieldName];
          field1List.add(field1);
        }
        field1List.sort();
        if (noneValue != null && field1List.length > 0) {
          field1List.add(noneValue);
        }
        return CustomDropDownRow(
          currentValue: currentValue,
          itemList: field1List,
          hintText: hintText,
          defaultText: defaultText,
          onChangeCallback: onChangeCallback,
        );
      },
    );
  }
}
