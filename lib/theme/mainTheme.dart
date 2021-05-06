import 'package:flutter/material.dart';

ThemeData getMainTheme() {
  return ThemeData(
    primaryColor: Colors.white,
    primaryColorBrightness: Brightness.light,
    brightness: Brightness.light,
    primaryColorDark: Colors.black,
    canvasColor: Colors.white,
    appBarTheme: AppBarTheme(brightness: Brightness.light),
  );
}

ThemeData getMainDarkTheme() {
  return ThemeData(
    primaryColor: Colors.black,
    primaryColorBrightness: Brightness.dark,
    primaryColorLight: Colors.black,
    brightness: Brightness.dark,
    primaryColorDark: Colors.black,
    indicatorColor: Colors.white,
    canvasColor: Colors.black,
    // next line is important!
    appBarTheme: AppBarTheme(brightness: Brightness.dark),
  );
}
