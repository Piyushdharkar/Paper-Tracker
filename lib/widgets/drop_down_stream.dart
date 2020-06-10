import 'package:flutter/material.dart';
import 'package:papertracker/widgets/drop_down_row.dart';

class DropDownStream<T, U> extends StatelessWidget {
  DropDownStream(
    this.stream, {
    @required this.currentValue,
    @required this.fieldName,
    this.field2Name,
    this.hintText,
    this.defaultText,
    this.noneValue,
    this.onChangeCallback,
  });

  bool get enabledField2 => field2Name != null;

  final stream;
  final T currentValue;
  final String fieldName;
  final String field2Name;
  final String hintText;
  final String defaultText;
  final T noneValue;
  final Function onChangeCallback;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) {
        final List<T> itemList = [];
        final Map<T, U> map = field2Name == null ? null : {};
        final items = snapshot.data.documents;
        for (var item in items) {
          T value = item.data[fieldName];
          if (enabledField2) {
            U name = item.data[field2Name];
            map[value] = name;
          }
          itemList.add(value);
        }
        itemList.sort();
        if (noneValue != null) {
          itemList.add(noneValue);
        }
        return DropDownRow(
          currentValue: currentValue,
          items: itemList,
          map: map,
          hintText: hintText,
          defaultText: defaultText,
          onChangeCallback: (value, name) {
            onChangeCallback(value, name);
          },
        );
      },
    );
  }
}
