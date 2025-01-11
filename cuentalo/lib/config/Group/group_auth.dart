import 'package:cuentalo/config/preferences/pref_password.dart';
import 'package:cuentalo/presentation/screens.dart';

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

  sumarContador(BuildContext context, int valor) {
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
      print('Yago: comprobando contraseña');
      try {
        
      comprobarContrasena(context);
      } catch (e) {
      print('Yago: ' +e.toString());
      }
    }
  }

  static comprobarContrasena(BuildContext context) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final FirebaseAuth auth = FirebaseAuth.instance;
    final prefs = PreferenciasUsuario();
    final p = PreferenciasPassword();

    try {
      final DocumentSnapshot future = await firestore
          .collection('Cuentalo')
          .doc('Groups')
          .collection(prefs.ultimaPagina)
          .doc('Info')
          .get();

      if (future.exists) {
        final String password = future['password'];
        final String passwordIntroducida = p.n1.toString()+p.n2.toString()+p.n3.toString()+p.n4.toString();

        if (passwordIntroducida == password) {
          try {
            await firestore
                .collection('Cuentalo')
                .doc('Users')
                .collection(auth.currentUser!.email!)
                .doc('Groups')
                .update({prefs.ultimaPagina: passwordIntroducida});
            context.pushReplacement('/');
          } catch (e) {
            showSnackBar(context, 'Error con el inicio sesion');
          }
        }
      } else {
        showSnackBar(context, 'No se encontro el grupo');
      }
    } catch (e) {
      showSnackBar(context, 'Error en el primer try');
    }
  }

  buscarGrupo(BuildContext context, TextEditingController nameController) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final prefs = PreferenciasUsuario();

    prefs.ultimaPagina = nameController.text;


    final DocumentSnapshot future = await firestore
        .collection('Cuentalo')
        .doc('Groups')
        .collection(nameController.text)
        .doc('Info')
        .get();

        if (future.exists) {
          context.push('/joinPassword');
          showSnackBar(context, nameController.text);
        } else{ 
          showSnackBar(context, 'No se encontro el grupo');
        }

    
  }



}
