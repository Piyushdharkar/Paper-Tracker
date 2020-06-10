import 'package:flutter/material.dart';

class DropDownRow<T, U> extends StatelessWidget {
  DropDownRow({
    @required this.currentValue,
    @required this.items,
    this.map,
    this.hintText,
    this.defaultText,
    this.onChangeCallback,
  });

  bool get enabledField2 => map != null;

  final T currentValue;
  final List<T> items;
  final Map<T, U> map;
  final String hintText;
  final String defaultText;
  final Function onChangeCallback;

  DropdownMenuItem<T> _buildDropDownMenuItem(T item) {
    String name = enabledField2 ? map[item].toString() : null;

    return DropdownMenuItem(
      child: enabledField2
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
      hint: items.length > 0 ? Text(hintText ?? '') : Text(defaultText ?? ''),
      value: items.contains(currentValue) ? currentValue : null,
      items: items.map(_buildDropDownMenuItem).toList(),
      onChanged: (value) {
        U name;
        name = enabledField2 ? map[value] : null;

        onChangeCallback(value, name);
      },
    );
  }
}
