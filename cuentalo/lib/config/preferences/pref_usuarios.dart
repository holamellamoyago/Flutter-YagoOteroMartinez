import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasUsuario {
  //Generar la instancia.
  static late SharedPreferences prefs;

  bool get emisor {
    return prefs.getBool('emisor') ?? false;
  }

  set emisor(bool value) {
    prefs.setBool('emisor', value);
  }

    // CAMBIAR CUANDO VAYA A PRODUCCION !!!!!!!
  String get generarUuid {
    return prefs.getString('generarUuid') ?? Random().nextInt(999999).toString();
    // Random().nextInt(999999).toString()
  }
  // set generarUuid(String value) {
  //   prefs.setString('generarUuid', value);
  // }

// Hacerlo obligatorio , quitar el ?? , poner !
  int get uuid {
    return prefs.getInt('uuid')!;
  }

  set uuid(int value) {
    prefs.setInt('uuid', value);
  }

  //Inicializar las preferencias
  static Future init() async {
    prefs = await SharedPreferences.getInstance();
  }

  String get ultimaPagina {
    return prefs.getString('ultimaPagina') ?? '/tutorial_screen';
  }

  set ultimaPagina(String value) {
    prefs.setString('ultimaPagina', value);
  }

  String get ultimouid {
    return prefs.getString('ultimouid') ?? '';
  }

  set ultimouid(String value) {
    prefs.setString('ultimouid', value);
  }

  String get username {
    return prefs.getString('username') ?? '';
  }

  set username(String value) {
    prefs.setString('username', value);
  }

  bool get isAdmin {
    return prefs.getBool('isAdmin') ?? true;
  }

  set isAdmin(bool value) {
    prefs.setBool('isAdmin', value);
  }

  String get token {
    return prefs.getString('token') ?? '';
  }

  set token(String value) {
    prefs.setString('token', value);
  }
  String get nombreGrupo {
    return prefs.getString('nombreGrupo') ?? '';
  }

  set nombreGrupo(String value) {
    prefs.setString('nombreGrupo', value);
  }






  /// TODO ARreglar 
    int get id {
    return prefs.getInt('id')!;
  }

  set id(int value) {
    prefs.setInt('id', value);
  }

}
