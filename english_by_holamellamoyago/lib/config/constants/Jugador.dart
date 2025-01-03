// ignore_for_file: file_names, prefer_typing_uninitialized_variables

import 'package:shared_preferences/shared_preferences.dart';

class Jugador {
  static late SharedPreferences jugador;

  static Future init() async {
    return jugador = await SharedPreferences.getInstance();
  }

  // UID

  String get uid {
    return jugador.getString('uid') ?? 'No UID';
  }

  set uid(String value) {
    jugador.setString('uid', value);
  }

  // NICKNAME

  String get nickname {
    return jugador.getString('nickname') ?? 'No nickname';
  }

  set nickname(String value) {
    jugador.setString('nickname', value);
  }

  // Logueado

  bool get logueado{
    return jugador.getBool('logueado') ?? false;
  }

  set logueado(bool value) {
    jugador.setBool('logueado', value);
  }
  
  // Email

    String get email {
    return jugador.getString('email') ?? 'No nickname';
  }

  set email(String value) {
    jugador.setString('email', value);
  }
}
