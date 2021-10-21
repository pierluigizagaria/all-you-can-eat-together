import 'package:allyoucaneattogether/models/order.dart';
import 'package:flutter/material.dart';

class OrderTile extends StatefulWidget {
  final Order _order;

  const OrderTile({Key? key, required order})
      : _order = order,
        super(key: key);

  @override
  _OrderTileState createState() => _OrderTileState();
}

class _OrderTileState extends State<OrderTile> {
  @override
  Widget build(BuildContext context) {
    widget._order.items.sort();
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 34,
            backgroundColor: widget._order.color,
            child: const Icon(
              Icons.person_rounded,
              color: Colors.white,
              size: 42,
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Wrap(
                spacing: 4,
                runSpacing: 4,
                children: List<Widget>.generate(
                  widget._order.items.length,
                  (int index) {
                    return Chip(
                      labelStyle: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                      backgroundColor: widget._order.color,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      label: Text(
                        widget._order.items[index].toString(),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
