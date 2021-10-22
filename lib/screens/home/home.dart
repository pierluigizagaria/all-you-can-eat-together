import 'package:allyoucaneattogether/models/group.dart';
import 'package:allyoucaneattogether/models/order.dart';
import 'package:allyoucaneattogether/models/user.dart';
import 'package:allyoucaneattogether/repository/groups.dart';
import 'package:allyoucaneattogether/repository/orders.dart';
import 'package:allyoucaneattogether/screens/orders/orders.dart';
import 'package:allyoucaneattogether/screens/table_qr_code_scanner.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameFieldController = TextEditingController();
  final _nameFieldFocusNode = FocusNode();
  bool _creatingTable = false;

  Future<Order> getUserOrder(Group group, User user) async {
    List<Order> orders = await OrdersRepository(group).findUserOrders(user);
    if (orders.isNotEmpty) return orders.first;
    Color color = RandomColor().randomColor(
      colorSaturation: ColorSaturation.highSaturation,
      colorBrightness: ColorBrightness.dark,
    );
    final order = Order(user: user, color: color, items: []);
    return OrdersRepository(group).add(order);
  }

  void _onCreateTableButtonPress(context) async {
    if (!_formKey.currentState!.validate()) return;
    _nameFieldFocusNode.unfocus();
    setState(() {
      _creatingTable = true;
    });
    try {
      User? user = Provider.of<User?>(context, listen: false);
      if (user == null) throw ErrorDescription('User is not authenticated');
      Group group = await GroupRepository().create();
      user.name = _nameFieldController.text;
      Order order = await getUserOrder(group, user);
      await Navigator.pushNamed(
        context,
        OrdersScreen.routeName,
        arguments: {'group': group, 'order': order},
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Non è stato possibile creare il tuo tavolo'),
        ),
      );
    }
    setState(() {
      _creatingTable = false;
    });
  }

  void _onJoinTableButtonPress(context) async {
    if (!_formKey.currentState!.validate()) return;
    _nameFieldFocusNode.unfocus();
    String? code = await Navigator.pushNamed(
      context,
      TableQRCodeScannerScreen.routeName,
    ) as String?;
    if (code == null) return;
    try {
      User? user = Provider.of<User?>(context, listen: false);
      if (user == null) throw ErrorDescription('User is not authenticated');
      Group? group = await GroupRepository().findGroup(code);
      if (group == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Il tavolo non esiste'),
          ),
        );
        return;
      }
      Order order = await getUserOrder(group, user);
      order.user.name = _nameFieldController.text;
      await OrdersRepository(group).update(order);
      await Navigator.pushNamed(
        context,
        OrdersScreen.routeName,
        arguments: {'group': group, 'order': order},
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Non è stato possibile creare il tuo tavolo'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        body: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 280,
                  child: TextFormField(
                    focusNode: _nameFieldFocusNode,
                    maxLength: 16,
                    controller: _nameFieldController,
                    style: const TextStyle(fontSize: 16),
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      labelText: 'Come ti chiami?',
                      alignLabelWithHint: true,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Inserisci il tuo nome';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 136,
                      child: ElevatedButton(
                        onPressed: _creatingTable
                            ? null
                            : () {
                                _onCreateTableButtonPress(context);
                              },
                        child: const Text('Crea'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 136,
                      child: ElevatedButton(
                        onPressed: _creatingTable
                            ? null
                            : () {
                                _onJoinTableButtonPress(context);
                              },
                        child: const Text('Unisciti'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
