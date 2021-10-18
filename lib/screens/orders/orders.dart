import 'package:allyoucaneattogether/models/group.dart';
import 'package:allyoucaneattogether/models/order.dart';
import 'package:allyoucaneattogether/models/user.dart';
import 'package:allyoucaneattogether/repository/groups.dart';
import 'package:allyoucaneattogether/screens/home/order_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:random_color/random_color.dart';

class OrdersScreen extends StatelessWidget {
  static const String routeName = '/orders';

  final Stream<Group?> _stream;
  final Color _orderColor = RandomColor()
      .randomColor(colorSaturation: ColorSaturation.highSaturation);
  final SnackBar _errorSnackBar = const SnackBar(
    content: Text('Il gruppo non esiste più'),
    behavior: SnackBarBehavior.floating,
  );

  OrdersScreen({Key? key, required group})
      : _stream = GroupRepository().getGroupStream(group),
        super(key: key) {
    _addOrderToGroup();
  }

  void _addOrderToGroup() {
    final order =
        Order(user: UserData(name: '', uid: ''), color: _orderColor, items: []);
    _stream.first.then((group) {
      if (group == null) return;
      group.orders.add(order);
      GroupRepository().update(group);
    });
  }

  @override
  Widget build(BuildContext context) {
    _stream.listen((event) {
      if (event != null) return;
      ScaffoldMessenger.of(context).showSnackBar(_errorSnackBar);
      Navigator.pop(context);
    });

    return StreamProvider<Group?>.value(
      initialData: null,
      value: _stream,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Ordini'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
            backgroundColor: _orderColor,
          ),
          floatingActionButton: SizedBox(
            height: 72,
            child: FittedBox(
              child: FloatingActionButton(
                backgroundColor: _orderColor,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Icon(Icons.edit),
              ),
            ),
          ),
          body: const OrdersList(),
        ),
      ),
    );
  }
}
