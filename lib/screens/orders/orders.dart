import 'package:allyoucaneattogether/models/group.dart';
import 'package:allyoucaneattogether/models/order.dart';
import 'package:allyoucaneattogether/screens/orders/order_edit_form.dart';
import 'package:allyoucaneattogether/repository/groups.dart';
import 'package:allyoucaneattogether/repository/orders.dart';
import 'package:allyoucaneattogether/screens/orders/order_list.dart';
import 'package:allyoucaneattogether/screens/table_qr_code_viewer.dart';
import 'package:allyoucaneattogether/utils/safe_modal_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

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
      : _stream = GroupRepository().stream(group),
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

  void _showSettingsPanel(BuildContext context, Group group, Order order) {
    SafeModalBottomSheet.show(
      context: context,
      body: OrderEditForm(group, order),
    );
  }

  void _showQRCodePanel(BuildContext context, String code) {
    SafeModalBottomSheet.show(
      context: context,
      body: SizedBox(
        height: 250,
        child: Center(
          child: SizedBox(
            height: 200,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: QrImage(
                backgroundColor: Colors.white,
                data: code,
                version: QrVersions.auto,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    popOnGroupNull();
  }

  @override
  Widget build(BuildContext context) {
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
          floatingActionButtonLocation:
              FloatingActionButtonLocation.miniCenterDocked,
          floatingActionButton: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 72,
                  child: FittedBox(
                    child: FloatingActionButton(
                      heroTag: 'qrCodeActionButton',
                      backgroundColor: widget._order.color,
                      onPressed: () {
                        _showQRCodePanel(context, widget._group.code);
                      },
                      child: const Icon(Icons.qr_code_rounded),
                    ),
                  ),
                ),
                SizedBox(
                  height: 72,
                  child: FittedBox(
                    child: FloatingActionButton(
                      heroTag: 'editActionButton',
                      backgroundColor: widget._order.color,
                      onPressed: () => _showSettingsPanel(
                        context,
                        widget._group,
                        widget._order,
                      ),
                      child: const Icon(Icons.edit),
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: const OrdersList(),
        ),
      ),
    );
  }
}
