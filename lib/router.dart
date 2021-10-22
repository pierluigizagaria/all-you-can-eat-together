import 'package:gosushi/models/group.dart';
import 'package:gosushi/models/order.dart';
import 'package:gosushi/screens/home/home.dart';
import 'package:gosushi/screens/orders/orders.dart';
import 'package:gosushi/screens/table_qr_code_scanner.dart';
import 'package:flutter/material.dart';

abstract class AppRouter {
  static Route<dynamic>? generateRoute(
    RouteSettings settings,
  ) {
    switch (settings.name) {
      case OrdersScreen.routeName:
        Map data = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute<String>(
          builder: (context) => OrdersScreen(
            group: data['group'] as Group,
            order: data['order'] as Order,
          ),
        );

      case (TableQRCodeScannerScreen.routeName):
        return MaterialPageRoute<String>(
          builder: (context) => const TableQRCodeScannerScreen(),
        );

      default:
        return MaterialPageRoute(builder: (context) => const HomeScreen());
    }
  }
}
