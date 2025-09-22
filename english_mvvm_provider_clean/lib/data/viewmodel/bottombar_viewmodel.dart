import 'package:english_mvvm_provider_clean/data/view/home_screen/home_screen.dart';
import 'package:english_mvvm_provider_clean/data/view/profile_screen/profile_screen.dart';
import 'package:english_mvvm_provider_clean/data/view/puntuation_screen/puntuation_screen.dart';
import 'package:english_mvvm_provider_clean/data/view/social_screen/social_screen.dart';
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
    ProfileScreen(),
  ];

  void changeScreen(int i) {
    selectedIndex = i;
    notifyListeners();
  }
}
