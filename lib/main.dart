import 'package:allyoucaneattogether/models/group.dart';
import 'package:allyoucaneattogether/screens/home/home.dart';
import 'package:allyoucaneattogether/screens/orders/orders.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FirebaseWrapper());
}

class FirebaseWrapper extends StatefulWidget {
  const FirebaseWrapper({Key? key}) : super(key: key);

  @override
  _FirebaseWrapperState createState() => _FirebaseWrapperState();
}

class _FirebaseWrapperState extends State<FirebaseWrapper> {
  bool _initialized = false;
  bool _error = false;

  void initializeFlutterFire() async {
    try {
      await Firebase.initializeApp();
      setState(() => _initialized = true);
    } catch (e) {
      setState(() => _error = true);
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_error) {
      return MaterialApp(
        title: 'Errore',
        home: Center(
          child: Container(
            color: Colors.orange,
          ),
        ),
      );
    }

    if (!_initialized) {
      return MaterialApp(
        title: 'Loading',
        home: Center(
          child: Container(
            color: Colors.orange,
          ),
        ),
      );
    }

    return const App();
  }
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        appBarTheme: const AppBarTheme(elevation: 0),
      ),
      initialRoute: HomeScreen.routeName,
      routes: {
        HomeScreen.routeName: (context) => const HomeScreen(),
        OrdersScreen.routeName: (context) => OrdersScreen(
              group: ModalRoute.of(context)!.settings.arguments as Group?,
            )
      },
    );
  }
}
