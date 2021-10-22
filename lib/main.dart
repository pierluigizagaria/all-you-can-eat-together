import 'package:gosushi/models/user.dart';
import 'package:gosushi/pages/loading.dart';
import 'package:gosushi/router.dart';
import 'package:gosushi/services/auth.dart';
import 'package:gosushi/themes.dart';
import 'package:gosushi/widgets/flutter_initializer.dart';
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
          initialData: AuthService().user,
          value: AuthService().stream,
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
