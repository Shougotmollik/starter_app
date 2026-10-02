import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData theme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: Colors.black45,
      onPrimary: Colors.white,
      secondary: Colors.deepOrange,
      onSecondary: Colors.white,
      error: Colors.redAccent,
      onError: Colors.white,
      surface: Colors.black45,
      onSurface: Colors.white,
    ),
  );
}
