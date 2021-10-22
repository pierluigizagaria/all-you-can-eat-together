import 'package:gosushi/services/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class FirebaseInitializer extends StatefulWidget {
  final Widget Function(BuildContext) onDidInitilize;
  final Widget Function(BuildContext) onLoading;
  final Widget Function(BuildContext) onError;

  const FirebaseInitializer({
    Key? key,
    required this.onDidInitilize,
    required this.onLoading,
    required this.onError,
  }) : super(key: key);

  @override
  _FirebaseInitializerState createState() => _FirebaseInitializerState();
}

class _FirebaseInitializerState extends State<FirebaseInitializer> {
  bool _initialized = false;
  bool _error = false;

  void initializeFlutterFire() async {
    try {
      await Firebase.initializeApp();
      if (AuthService().user == null) {
        await AuthService().signInAnonimously();
      }
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
      return widget.onError(context);
    }
    if (!_initialized) {
      return widget.onLoading(context);
    }
    return widget.onDidInitilize(context);
  }
}
