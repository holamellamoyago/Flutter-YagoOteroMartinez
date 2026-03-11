import 'package:plantilla_flutter/presentation/screens.dart';


class PreferenciasUsuario {
  static late SharedPreferences prefs;

  static Future init() async {
    prefs = await SharedPreferences.getInstance();
  }

  // CAMBIAR CUANDO VAYA A PRODUCCION !!!!!!!
  String get generarUuid {
    return prefs.getString('generarUuid') ?? '123456789';
  }

  set generarUuid(String value) {
    prefs.setString('generarUuid', value);
  }

// Hacerlo obligatorio , quitar el ?? , poner ! 
  String get uuid {
    return prefs.getString('uuid') ?? '123456789';
  }

  set uuid(String value) {
    prefs.setString('uuid', value);
  }


}
