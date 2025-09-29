import 'package:english_mvvm_provider_clean/config/app_colors.dart';
import 'package:flutter/material.dart';

class ThemedataViewmodel extends ChangeNotifier {
  bool isLight = true;

  ThemeData get() => isLight ? themeDataLight : ThemeData.dark();

  ThemeData themeDataLight = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
    fontFamily: "Comic Relief",

    // Main Screen
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        fontSize: 72,
        fontWeight: FontWeight.w900,
        color: Colors.white,
        shadows: [
          Shadow(offset: Offset(5, 5), color: AppColors.borderTitle2),
          Shadow(offset: Offset(3, 2.5), color: AppColors.borderTitle1),
        ],
      ),
      // Título del dialog Timer
      headlineMedium: TextStyle(fontSize: 32, fontWeight: FontWeight.w900),
      headlineSmall: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w900,
        color: Colors.white,
      ),
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
