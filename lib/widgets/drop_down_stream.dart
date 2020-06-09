import 'package:flutter/material.dart';
import 'package:papertracker/widgets/drop_down_row.dart';

class DropDownStream<T, U> extends StatelessWidget {
  DropDownStream(@required this.stream,
      {@required this.currentValue,
      this.currentName,
      @required this.fieldName,
      this.field2Name,
      this.onChangeCallback});

  final stream;
  final T currentValue;
  final U currentName;
  final String fieldName;
  final String field2Name;
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
          if (field2Name != null) {
            U name = item.data[field2Name];
            map[value] = name;
          }
          itemList.add(value);
        }
        itemList.sort();
        return DropDownRow(
          currentValue: currentValue,
          items: itemList,
          map: map,
          onChangeCallback: (value, name) {
            onChangeCallback(value, name);
          },
        );
      },
    );
  }
}
