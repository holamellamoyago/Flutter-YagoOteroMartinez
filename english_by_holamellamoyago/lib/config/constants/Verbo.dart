// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: prefer_typing_uninitialized_final Stringiables

import 'package:shared_preferences/shared_preferences.dart';

enum Respuesta { sinContestar, fallido, acertado }

class Verbo {
  static late SharedPreferences verbo;

  static Future init() async {
    return verbo = await SharedPreferences.getInstance();
  }

    String get verboInfinitivo {
      return verbo.getString('verboInfinitivo') ?? 'No verbo configurado';
    }

    set verboInfinitivo(String value) {
      verbo.setString('verboInfinitivo', value);
    }

  String get pasadoSimple {
    return verbo.getString('pasadoSimple') ?? 'No verbo configurado';
  }

  set pasadoSimple(String value) {
    verbo.setString('pasadoSimple', value);
  }

  String get pasadoParticipio {
    return verbo.getString('pasadoParticipio') ?? 'No verbo configurado';
  }

  set pasadoParticipio(String value) {
    verbo.setString('pasadoParticipio ', value);
  }

  String get traduccion {
    return verbo.getString('traduccion') ?? 'No verbo configurado';
  }

  set traduccion(String value) {
    verbo.setString('traduccion', value);
  }
}
