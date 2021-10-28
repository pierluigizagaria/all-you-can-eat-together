import 'package:gosushi/models/order.dart';
import 'package:flutter/material.dart';

class OrderTile extends StatelessWidget {
  final Order _order;

  const OrderTile({Key? key, required order})
      : _order = order,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    _order.items.sort();
    Map<int, int> countedItems = {
      for (int item in _order.items)
        item: _order.items.where((element) => element == item).length
    };
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 34,
            backgroundColor: _order.color,
            child: const Icon(
              Icons.person_rounded,
              color: Colors.white,
              size: 42,
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      _order.user.name,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: List<Widget>.generate(
                      countedItems.length,
                      (int index) {
                        int key = countedItems.keys.elementAt(index);
                        return Chip(
                          labelStyle: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                          backgroundColor: _order.color,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          label: Text(countedItems[key]! > 1
                              ? '${key.toString()} x ${countedItems[key].toString()}'
                              : key.toString()),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
