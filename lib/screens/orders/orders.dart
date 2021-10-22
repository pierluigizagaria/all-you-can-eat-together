import 'dart:async';
import 'package:gosushi/models/group.dart';
import 'package:gosushi/models/order.dart';
import 'package:gosushi/screens/orders/order_edit_form.dart';
import 'package:gosushi/repository/groups.dart';
import 'package:gosushi/repository/orders.dart';
import 'package:gosushi/screens/orders/order_list.dart';
import 'package:gosushi/utils/safe_modal_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class OrdersScreen extends StatefulWidget {
  static const String routeName = '/orders';

  final Stream<Group?> _stream;
  final Group _group;
  final Order _order;

  final SnackBar _snackBarError = const SnackBar(
    content: Text('Il tavolo non esiste più'),
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
  late StreamSubscription _streamSubscription;

  void popOnGroupNull() {
    _streamSubscription = widget._stream.listen((event) {
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

  void _showOrdersAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text("Comanda"),
          content: null,
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    popOnGroupNull();
  }

  @override
  void dispose() {
    super.dispose();
    _streamSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Order>?>.value(
      initialData: const [],
      value: OrdersRepository(widget._group).orders,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Ordini'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.list_alt_rounded, color: Colors.white),
              onPressed: () => _showOrdersAlertDialog(context),
            )
          ],
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
                    onPressed: () =>
                        _showQRCodePanel(context, widget._group.code),
                    child: const Icon(Icons.qr_code_rounded),
                  ),
                ),
              ),
              SizedBox(
                height: 72,
                child: FittedBox(
                  child: FloatingActionButton(
                    heroTag: 'editActionButton',
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
    );
  }
}
