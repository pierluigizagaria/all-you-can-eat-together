import 'package:flutter/material.dart';

abstract class Themes {
  static final ThemeData _shared = ThemeData(
    primaryColor: const Color(0xFFE2062C),
    primarySwatch: Colors.red,
    appBarTheme: const AppBarTheme(
      color: Color(0xFFE2062C),
      elevation: 0,
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: ZoomPageTransitionsBuilder(),
      },
    ),
    inputDecorationTheme: const InputDecorationTheme(
      labelStyle: TextStyle(color: Color(0xFFE2062C)),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          style: BorderStyle.solid,
          color: Color(0xFFE2062C),
        ),
      ),
    ),
  );

  static final ThemeData lightTheme = _shared.copyWith();

  static final ThemeData darkTheme = _shared.copyWith(
    scaffoldBackgroundColor: Colors.black,
    textTheme: Typography().white,
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: Colors.grey.shade900,
    ),
  );
}
