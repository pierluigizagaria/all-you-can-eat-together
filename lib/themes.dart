import 'package:flutter/material.dart';

abstract class Themes {
  static final ThemeData _shared = ThemeData(
    primarySwatch: Colors.red,
    brightness: Brightness.light,
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: ZoomPageTransitionsBuilder(),
      },
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.white,
    ),
  );

  static final ThemeData lightTheme = _shared.copyWith();

  static final ThemeData darkTheme = _shared.copyWith(
    textTheme: Typography().white,
    scaffoldBackgroundColor: Colors.black,
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: Colors.grey.shade900,
    ),
    dialogBackgroundColor: Colors.grey.shade900,
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: const TextStyle(color: Colors.white),
      floatingLabelStyle: TextStyle(color: Colors.red.shade400),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
      counterStyle: const TextStyle(color: Colors.white),
    ),
  );
}
