import 'package:allyoucaneattogether/models/group.dart';
import 'package:allyoucaneattogether/models/order.dart';
import 'package:allyoucaneattogether/screens/orders/order_edit_form.dart';
import 'package:allyoucaneattogether/repository/groups.dart';
import 'package:allyoucaneattogether/repository/orders.dart';
import 'package:allyoucaneattogether/screens/home/order_list.dart';
import 'package:allyoucaneattogether/utils/safe_modal_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatefulWidget {
  static const String routeName = '/orders';

  final Stream<Group?> _stream;
  final Group _group;
  final Order _order;

  final SnackBar _snackBarError = const SnackBar(
    content: Text('Il gruppo non esiste più'),
    behavior: SnackBarBehavior.floating,
  );

  OrdersScreen({Key? key, required group, required order})
      : _stream = GroupRepository().getGroupStream(group),
        _group = group,
        _order = order,
        super(key: key);

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  void popOnGroupNull() {
    widget._stream.listen((event) {
      if (event != null) return;
      ScaffoldMessenger.of(context).showSnackBar(widget._snackBarError);
      Navigator.pop(context);
    });
  }

  @override
  void initState() {
    super.initState();
    popOnGroupNull();
  }

  @override
  Widget build(BuildContext context) {
    void _showSettingsPanel(Group group, Order order) {
      SafeModalBottomSheet.show(
        context: context,
        body: OrderEditForm(group, order),
      );
    }

    return StreamProvider<List<Order>>.value(
      initialData: const [],
      value: OrdersRepository(widget._group).orders,
      child: Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.fromSwatch().copyWith(
            secondary: widget._order.color,
          ),
        ),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: const Text('Ordini'),
            backgroundColor: widget._order.color,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          floatingActionButton: SizedBox(
            height: 72,
            child: FittedBox(
              child: FloatingActionButton(
                backgroundColor: widget._order.color,
                onPressed: () =>
                    _showSettingsPanel(widget._group, widget._order),
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
