import 'package:flutter/material.dart';

class DropDownRow<T, U> extends StatelessWidget {
  DropDownRow({
    @required this.currentValue,
    @required this.field1List,
    this.field1Tofield2Map,
    this.hintText,
    this.defaultText,
    this.onChangeCallback,
  });

  bool get enabledField2 => field1Tofield2Map != null;

  final T currentValue;
  final List<T> field1List;
  final Map<T, U> field1Tofield2Map;
  final String hintText;
  final String defaultText;
  final Function onChangeCallback;

  DropdownMenuItem<T> _buildDropDownMenuItem(T item) {
    String name = enabledField2 ? field1Tofield2Map[item].toString() : null;

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
      hint: field1List.length > 0 ? Text(hintText ?? '') : Text(defaultText ?? ''),
      value: field1List.contains(currentValue) ? currentValue : null,
      items: field1List.map(_buildDropDownMenuItem).toList(),
      onChanged: (value) {
        U name = enabledField2 ? field1Tofield2Map[value] : null;
        onChangeCallback(value, name);
      },
    );
  }
}
