import 'package:allyoucaneattogether/models/group.dart';
import 'package:allyoucaneattogether/models/order.dart';
import 'package:allyoucaneattogether/models/user.dart';
import 'package:allyoucaneattogether/repository/groups.dart';
import 'package:allyoucaneattogether/repository/orders.dart';
import 'package:allyoucaneattogether/screens/orders/orders.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:random_color/random_color.dart';

class GroupCodeTextField extends StatefulWidget {
  const GroupCodeTextField({Key? key}) : super(key: key);

  @override
  _GroupCodeTextFieldState createState() => _GroupCodeTextFieldState();
}

class _GroupCodeTextFieldState extends State<GroupCodeTextField> {
  String _oldInputValue = '';
  String _error = '';

  Future<Order> addOrderToGroup(Group group, User user, Color color) {
    final order = Order(user: user, color: color, items: []);
    return OrdersRepository(group).add(order);
  }

  Future<Order> getOrderOrCreate(Group group, User user) async {
    List<Order> userOrders =
        await OrdersRepository(group).getOrdersByUser(user);

    if (userOrders.isNotEmpty) return userOrders.first;

    Order newOrder = await addOrderToGroup(
      group,
      user,
      RandomColor().randomColor(
        colorSaturation: ColorSaturation.highSaturation,
        colorBrightness: ColorBrightness.dark,
      ),
    );
    return newOrder;
  }

  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<User?>(context);

    return TextField(
      style: const TextStyle(fontSize: 32),
      textAlign: TextAlign.center,
      maxLength: Group.codeLength,
      textCapitalization: TextCapitalization.characters,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp('^[a-zA-Z0-9]*')),
      ],
      decoration: InputDecoration(errorText: _error, counterText: ''),
      onChanged: (value) async {
        if (value == _oldInputValue) {
          return;
        } else {
          _oldInputValue = value;
          if (_error != '') {
            setState(() => _error = '');
          }
        }
        if (value.length < Group.codeLength) return;

        if (user == null) {
          setState(() => _error = 'Errore');
          return;
        }

        Group? group = await GroupRepository().getGroupByCode(value);
        if (group == null) {
          setState(() => _error = 'Il gruppo non esiste');
          return;
        }

        Order order = await getOrderOrCreate(group, user);

        Navigator.pushNamed(
          context,
          OrdersScreen.routeName,
          arguments: {'group': group, 'order': order},
        );
      },
    );
  }
}
