import 'package:shared_preferences/shared_preferences.dart';

class Partida {
  static late SharedPreferences partida;

  static Future init() async {
    return partida = await SharedPreferences.getInstance();
  }

  int get contadorPartida {
    return partida.getInt('contadorPartida') ?? 0;
  }

  set contadorPartida(int value) {
    partida.setInt('contadorPartida', value);
  }
}
