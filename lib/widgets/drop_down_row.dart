import 'package:flutter/material.dart';

class DropDownRow<T, U> extends StatelessWidget {
  DropDownRow(
      {@required this.currentValue,
      @required this.items,
      this.map,
      this.onChangeCallback});

  final T currentValue;
  final List<T> items;
  final Map<T, U> map;
  final Function onChangeCallback;

  DropdownMenuItem<T> _buildDropDownMenuItem(T item) {
    String name = '';

    if (map != null) {
      name = map[item].toString();
    }

    return DropdownMenuItem(
      child: map != null
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${item.toString()}. '),
                Text(name),
              ],
            )
          : Text(
              item.toString(),
              overflow: TextOverflow.ellipsis,
            ),
      value: item,
    );
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<T>(
      isExpanded: true,
      value: currentValue,
      items: items.map(_buildDropDownMenuItem).toList(),
      onChanged: (value) {
        U name;
        if (map != null) {
          name = map[value];
        }
        onChangeCallback(value, name);
      },
    );
  }
}
