import 'package:flutter/material.dart';

class CustomDropDownRow<T, U> extends StatelessWidget {
  CustomDropDownRow({
    @required this.currentValue,
    @required this.itemList,
    this.hintText,
    this.defaultText,
    this.onChangeCallback,
  });

  final T currentValue;
  final List<T> itemList;
  final String hintText;
  final String defaultText;
  final Function onChangeCallback;

  DropdownMenuItem<T> _buildDropDownMenuItem(T item) {
    return DropdownMenuItem(
      child: Text(
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
      hint:
          itemList.length > 0 ? Text(hintText ?? '') : Text(defaultText ?? ''),
      value: itemList.contains(currentValue) ? currentValue : null,
      items: itemList.map(_buildDropDownMenuItem).toList(),
      onChanged: (value) {
        onChangeCallback(value);
      },
    );
  }
}
