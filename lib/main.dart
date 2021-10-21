import 'package:allyoucaneattogether/models/user.dart';
import 'package:allyoucaneattogether/pages/loading.dart';
import 'package:allyoucaneattogether/router.dart';
import 'package:allyoucaneattogether/services/auth.dart';
import 'package:allyoucaneattogether/themes.dart';
import 'package:allyoucaneattogether/widgets/flutter_initializer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatelessWidget {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FirebaseInitializer(
      onError: (context) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: Themes.lightTheme,
          home: Loading(),
        );
      },
      onLoading: (context) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: Themes.lightTheme,
          home: Loading(),
        );
      },
      onDidInitilize: (context) {
        return StreamProvider<User?>.value(
          initialData: AuthService().signedUser(),
          value: AuthService().user,
          updateShouldNotify: (previous, current) {
            return current?.uid != previous?.uid;
          },
          child: MaterialApp(
            title: 'Flutter Demo',
            theme: Themes.lightTheme,
            darkTheme: Themes.darkTheme,
            themeMode: ThemeMode.system,
            navigatorKey: _navigatorKey,
            onGenerateRoute: AppRouter.generateRoute,
          ),
        );
      },
    );
  }
}
