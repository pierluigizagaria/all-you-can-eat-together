import 'package:gosushi/models/order.dart';
import 'package:gosushi/repository/orders.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OrderEditForm extends StatefulWidget {
  final Order _order;
  final OrdersRepository _orderRepository;

  OrderEditForm(group, order, {Key? key})
      : _order = order,
        _orderRepository = OrdersRepository(group),
        super(key: key);

  @override
  _OrderEditFormState createState() => _OrderEditFormState();
}

class _OrderEditFormState extends State<OrderEditForm> {
  late List<int> _items;
  final _textEditingController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _items = widget._order.items;
  }

  void notifyUpdate() {
    widget._orderRepository.update(widget._order);
  }

  void _deleteItem(int value) {
    _items.remove(value);
    notifyUpdate();
    setState(() => _items);
  }

  void addChip(String value) {
    _items.add(int.parse(value));
    _items.sort();
    notifyUpdate();
    setState(() => _items);
  }

  List<Widget> chipsList() {
    Map<int, int> countedItems = {
      for (int item in _items)
        item: _items.where((element) => element == item).length
    };
    return List<Widget>.generate(
      countedItems.length,
      (int index) {
        int key = countedItems.keys.elementAt(index);
        return RawChip(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          onDeleted: () => _deleteItem(key),
          onPressed: () => _deleteItem(key),
          label: Text(countedItems[key]! > 1
              ? '${key.toString()} x ${countedItems[key].toString()}'
              : key.toString()),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      duration: const Duration(milliseconds: 0),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 5,
            margin: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey,
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 10, 24, 0),
              child: RawScrollbar(
                radius: const Radius.circular(20),
                thickness: 4,
                isAlwaysShown: true,
                controller: _scrollController,
                child: SingleChildScrollView(
                  reverse: true,
                  controller: _scrollController,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Wrap(
                      alignment: WrapAlignment.start,
                      spacing: 4,
                      runSpacing: 4,
                      children: chipsList(),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 18),
            child: TextField(
              controller: _textEditingController,
              autofocus: true,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              onSubmitted: (value) {
                _textEditingController.clear();
                if (int.tryParse(value) != null) addChip(value);
              },
              onEditingComplete: () => {},
            ),
          ),
        ],
      ),
    );
  }
}
