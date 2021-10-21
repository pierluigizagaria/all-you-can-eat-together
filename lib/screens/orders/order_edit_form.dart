import 'package:allyoucaneattogether/models/order.dart';
import 'package:allyoucaneattogether/repository/orders.dart';
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

  void removeChip(int index) {
    _items.removeAt(index);
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
    return List<Widget>.generate(
      _items.length,
      (int index) {
        return RawChip(
          labelStyle: const TextStyle(fontSize: 18),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          onDeleted: () => removeChip(index),
          onPressed: () => removeChip(index),
          label: Text(
            _items[index].toString(),
          ),
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
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 18),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  constraints: const BoxConstraints(maxHeight: 280),
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
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
                TextField(
                  controller: _textEditingController,
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  onSubmitted: (value) {
                    if (_items.length >= 30) return;
                    _textEditingController.clear();
                    if (int.tryParse(value) != null) {
                      addChip(value);
                    }
                  },
                  onEditingComplete: () => {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
