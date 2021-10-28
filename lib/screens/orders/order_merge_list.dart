import 'package:flutter/material.dart';

class OrderMergeList extends StatelessWidget {
  final Map<int, int> _items;
  const OrderMergeList({required items, Key? key})
      : _items = items,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: List<Widget>.generate(
        _items.length,
        (int index) {
          int key = _items.keys.elementAt(index);
          return Chip(
            labelStyle: const TextStyle(fontSize: 18),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            label: Text(_items[key]! > 1
                ? '${key.toString()} x ${_items[key].toString()}'
                : key.toString()),
          );
        },
      ),
    );
  }
}
