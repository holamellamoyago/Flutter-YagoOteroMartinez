import 'package:english_mvvm_provider_clean/presentation/home_screen/home_screen.dart';
import 'package:english_mvvm_provider_clean/presentation/settings_screen/settings_screen.dart';
import 'package:english_mvvm_provider_clean/presentation/puntuation_screen/puntuation_screen.dart';
import 'package:english_mvvm_provider_clean/presentation/social_screen/social_screen.dart';
import 'package:flutter/material.dart';

class BottombarViewmodel extends ChangeNotifier {
  int selectedIndex = 0;

  final List<BottomNavigationBarItem> lista = [
    BottomNavigationBarItem(
      icon: Icon(Icons.gamepad_outlined),
      label: "Play",
      // backgroundColor: Colors.red,
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.bar_chart_outlined),
      label: "Puntutation",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.people_alt_outlined),
      label: "Social",
    ),
    BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
  ];

  final List<Widget> screens = [
    HomeScreen(),
    PuntuationScreen(),
    SocialScreen(),
    SettingsScreen(),
  ];

  void changeScreen(int i) {
    selectedIndex = i;
    notifyListeners();
  }
}
