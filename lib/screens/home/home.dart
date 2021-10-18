import 'package:allyoucaneattogether/models/group.dart';
import 'package:allyoucaneattogether/repository/groups.dart';
import 'package:allyoucaneattogether/screens/orders/orders.dart';
import 'package:allyoucaneattogether/utils/upper_text_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const String routeName = '/';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          elevation: 0,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 150,
                width: 120,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [GroupCodeTextField()],
                ),
              ),
              ElevatedButton(
                child: Text('Crea gruppo'),
                onPressed: () {
                  GroupRepository().create();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class GroupCodeTextField extends StatefulWidget {
  const GroupCodeTextField({Key? key}) : super(key: key);

  @override
  _GroupCodeTextFieldState createState() => _GroupCodeTextFieldState();
}

class _GroupCodeTextFieldState extends State<GroupCodeTextField> {
  String _oldInputValue = '';
  String _error = '';

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: const TextStyle(fontSize: 32),
      textAlign: TextAlign.center,
      maxLength: Group.codeLength,
      inputFormatters: [
        UpperCaseTextFormatter(),
        FilteringTextInputFormatter.allow(RegExp('^[a-zA-Z0-9]*')),
      ],
      decoration: InputDecoration(errorText: _error, counterText: ''),
      onChanged: (value) async {
        if (value == _oldInputValue) {
          return;
        } else {
          _oldInputValue = value;
          setState(() => _error = '');
        }
        if (value.length < Group.codeLength) return;
        Group? group = await GroupRepository().getGroupByCode(value);
        if (group == null) {
          setState(() => _error = 'Group does not exists');
          return;
        }
        Navigator.pushNamed(context, OrdersScreen.routeName, arguments: group);
      },
    );
  }
}
