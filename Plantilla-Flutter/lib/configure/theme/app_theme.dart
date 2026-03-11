import 'package:flutter/material.dart';

class AppThemeCustom {
  ThemeData getTheme() => ThemeData(
      useMaterial3: true,
      appBarTheme: AppBarTheme(),
      colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Colors.white,
          onPrimary: Colors.black,
          secondary: Colors.grey,
          onSecondary: Colors.black,
          error: Colors.red,
          onError: Colors.yellow,
          surface: Colors.black,
          onSurface: Colors.white));
}
