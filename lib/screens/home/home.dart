import 'package:gosushi/models/group.dart';
import 'package:gosushi/models/order.dart';
import 'package:gosushi/models/user.dart';
import 'package:gosushi/repository/groups.dart';
import 'package:gosushi/repository/orders.dart';
import 'package:gosushi/screens/orders/orders.dart';
import 'package:gosushi/screens/table_qr_code_scanner.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
        body: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    color: Colors.red,
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).padding.top),
                      child: Stack(
                        alignment: Alignment.center,
                        children: const <Widget>[
                          AspectRatio(aspectRatio: 1),
                          Image(
                            width: 280,
                            image: AssetImage('assets/splash/splash.png'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 280,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
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
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _creatingTable
                              ? () {}
                              : () {
                                  _onCreateTableButtonPress(context);
                                },
                          child: !_creatingTable
                              ? const Text('Crea')
                              : const SpinKitRing(
                                  color: Colors.white,
                                  lineWidth: 3,
                                  size: 20,
                                ),
                        ),
                        const SizedBox(width: 12),
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 250),
                          opacity: !_creatingTable ? 1.0 : 0.0,
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
