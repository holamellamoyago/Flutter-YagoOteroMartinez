
import 'package:cuentalo/config/preferences/pref_password.dart';

class GroupAuth {

  final password = PreferenciasPassword();

    borrarnumero() {
      if (password.n4 != -1) {
        password.n4 = -1;
      } else if (password.n3 != -1) {
        password.n3 = -1;
      } else if (password.n2 != -1) {
        password.n2 = -1;
      } else if (password.n1 != -1) {
        password.n1 = -1;
      }
    
  }


    sumarContador(int valor) {
    final password = PreferenciasPassword();

      if (password.n1 == -1) {
        password.n1 = valor;
        print('n1 : ' + password.n1.toString());
      } else if (password.n2 == -1) {
        password.n2 = valor;
        print('n2 : ' + password.n2.toString());
      } else if (password.n3 == -1) {
        password.n3 = valor;
        print('n3 : ' + password.n3.toString());
      } else if (password.n4 == -1) {
        password.n4 = valor;
        print('n4 : ' + password.n4.toString());
      }
    
  }
}
