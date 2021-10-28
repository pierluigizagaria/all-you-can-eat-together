import 'package:flutter/material.dart';

abstract class Themes {
  static final ThemeData _shared = ThemeData.from(
    colorScheme: const ColorScheme(
      primary: Color(0xFFE43D1C),
      primaryVariant: Color(0xFFE43D1C),
      secondary: Color(0xFFE43D1C),
      secondaryVariant: Color(0xFFE43D1C),
      surface: Color(0xFFE43D1C),
      background: Colors.black,
      error: Colors.red,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.white,
      onBackground: Color(0xFFE43D1C),
      onError: Color(0xFFE43D1C),
      brightness: Brightness.dark,
    ),
  ).copyWith(
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: ZoomPageTransitionsBuilder(),
      },
    ),
    appBarTheme: const AppBarTheme(elevation: 0),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Color(0xFF191414),
    ),
    chipTheme: ChipThemeData.fromDefaults(
      secondaryColor: const Color(0xFF191414),
      brightness: Brightness.light,
      labelStyle: const TextStyle(fontSize: 18),
    ).copyWith(
      backgroundColor: Colors.white,
    ),
    dialogBackgroundColor: const Color(0xFF191414),
  );

  static ThemeData get light => _shared.copyWith();

  static ThemeData get dark => _shared.copyWith(
      /*
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
        */
      );
}


/*

import 'package:flutter/material.dart';

abstract class Themes {
  static final ThemeData _shared = ThemeData(
    primarySwatch: Colors.red,
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.red,
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      shape: StadiumBorder(side: BorderSide(color: Colors.white, width: 1)),
    ),
    chipTheme: ChipThemeData.fromDefaults(
      primaryColor: Colors.black,
      secondaryColor: Colors.white,
      labelStyle: TextStyle(color: Colors.black),
    ).copyWith(backgroundColor: Colors.white),
    appBarTheme: const AppBarTheme(
      foregroundColor: Colors.black,
      color: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black),
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: ZoomPageTransitionsBuilder(),
      },
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.red,
    ),
    textTheme: Typography().white.copyWith(
          button: TextStyle(color: Colors.red),
        ),
    textSelectionTheme: const TextSelectionThemeData(cursorColor: Colors.white),
    inputDecorationTheme: const InputDecorationTheme(
      labelStyle: TextStyle(color: Colors.white),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.white),
      ),
    ),
  );

  static ThemeData get light => _shared.copyWith();

  static ThemeData get dark => _shared.copyWith(
      //textTheme: Typography().white,
      //scaffoldBackgroundColor: Colors.black,
      //bottomSheetTheme: BottomSheetThemeData(
      //  backgroundColor: Colors.grey.shade900,
      //),
      //dialogBackgroundColor: Colors.grey.shade900,
      //inputDecorationTheme: InputDecorationTheme(
      //  labelStyle: const TextStyle(color: Colors.white),
      //  floatingLabelStyle: TextStyle(color: Colors.red.shade400),
      //  enabledBorder: const UnderlineInputBorder(
      //    borderSide: BorderSide(color: Colors.white),
      //  ),
      //  counterStyle: const TextStyle(color: Colors.white),
      //),
      );
}

*/
