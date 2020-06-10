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
        final List<T> field1List = [];
        final Map<T, U> field1Tofield2Map = field2Name == null ? null : {};
        final items = snapshot.data.documents;
        for (var item in items) {
          T field1 = item.data[fieldName];
          if (enabledField2) {
            U field2 = item.data[field2Name];
            field1Tofield2Map[field1] = field2;
          }
          field1List.add(field1);
        }
        field1List.sort();
        if (noneValue != null) {
          field1List.add(noneValue);
        }
        return DropDownRow(
          currentValue: currentValue,
          field1List: field1List,
          field1Tofield2Map: field1Tofield2Map,
          hintText: hintText,
          defaultText: defaultText,
          onChangeCallback: onChangeCallback,
        );
      },
    );
  }
}
