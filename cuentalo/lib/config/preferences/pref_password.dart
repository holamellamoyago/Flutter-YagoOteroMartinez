import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasPassword {
  //Generar la instancia.
  static late SharedPreferences password;

    static Future init() async {
    password = await SharedPreferences.getInstance();
  }

  /// TODO ARreglar 
  int get n1 {
    return password.getInt('n1') ?? -1;
  }

  set n1(int value) {
    password.setInt('n1', value);
  }
  int get n2 {
    return password.getInt('n2') ?? -1;
  }

  set n2(int value) {
    password.setInt('n2', value);
  }
  int get n3 {
    return password.getInt('n3') ?? -1;
  }

  set n3(int value) {
    password.setInt('n3', value);
  }
  int get n4 {
    return password.getInt('n4') ?? -1;
  }

  set n4(int value) {
    password.setInt('n4', value);
  }

}
