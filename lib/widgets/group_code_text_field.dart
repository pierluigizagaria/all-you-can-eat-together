import 'package:gosushi/models/group.dart';
import 'package:gosushi/models/order.dart';
import 'package:gosushi/models/user.dart';
import 'package:gosushi/repository/groups.dart';
import 'package:gosushi/repository/orders.dart';
import 'package:gosushi/screens/orders/orders.dart';
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
    List<Order> userOrders = await OrdersRepository(group).findUserOrders(user);

    if (userOrders.isNotEmpty) return userOrders.first;

    Color randomColor = RandomColor().randomColor(
      colorSaturation: ColorSaturation.highSaturation,
      colorBrightness: ColorBrightness.dark,
    );

    return await addOrderToGroup(group, user, randomColor);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: const TextStyle(fontSize: 16),
      maxLength: Group.codeLength,
      textCapitalization: TextCapitalization.characters,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp('^[a-zA-Z0-9]*')),
      ],
      decoration: InputDecoration(
        labelText: 'Codice gruppo',
        errorText: _error,
        counterText: '',
      ),
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

        User? user = Provider.of<User?>(context);
        if (user == null) {
          setState(() => _error = 'Errore');
          return;
        }

        Group? group = await GroupRepository().findGroup(value);
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
