import 'package:flutter/material.dart';

class ThemedataViewmodel extends ChangeNotifier {
  bool isLight = true;

  ThemeData get() => isLight ? themeDataLight : ThemeData.dark();

  ThemeData themeDataLight = ThemeData(
    fontFamily: "Comic Relief",
    textTheme: TextTheme(
      headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
      titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      bodyMedium: TextStyle(
        fontSize: 16,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      labelMedium: TextStyle(fontSize: 16, color: Colors.grey),
    ),
  );
}
