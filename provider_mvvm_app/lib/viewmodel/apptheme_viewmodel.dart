import 'package:flutter/material.dart';

class AppthemeViewmodel extends ChangeNotifier {
  bool _isLight = true;

  ThemeData get appTheme => _isLight ? _appThemeLight : _appThemeDark;

  final ThemeData _appThemeLight = ThemeData(colorSchemeSeed: Colors.orange);
  final ThemeData _appThemeDark = ThemeData(colorSchemeSeed: Colors.deepOrange);

  

  changeTheme() {
    _isLight = !_isLight;
    notifyListeners();
  }
}
