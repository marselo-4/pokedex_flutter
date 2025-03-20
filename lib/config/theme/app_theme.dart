import 'package:flutter/material.dart';

class AppTheme {
  ThemeData getLightTheme() => ThemeData(
    useMaterial3: true,
    colorSchemeSeed: const Color.fromARGB(255, 255, 255, 255),
    brightness: Brightness.light,
  );

  ThemeData getDarkTheme() => ThemeData(
    useMaterial3: true,
    colorSchemeSeed: const Color.fromARGB(255, 0, 0, 0),
    brightness: Brightness.dark,
  );
}