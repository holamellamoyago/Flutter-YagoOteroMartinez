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

  sumarContador(BuildContext context, int valor , bool creatingGroup) {
    final password = PreferenciasPassword();

    if (password.n1 == -1) {
      password.n1 = valor;
    } else if (password.n2 == -1) {
      password.n2 = valor;
    } else if (password.n3 == -1) {
      password.n3 = valor;
    } else if (password.n4 == -1) {
      password.n4 = valor;      
      creatingGroup ? crearGrupo(context) : comprobarContrasena(context);
      
    }
  }

    crearGrupo(BuildContext context) async {
    final firestore = FirebaseFirestore.instance;
    final FirebaseAuth auth = FirebaseAuth.instance;
        final p = PreferenciasPassword();

            final String passwordIntroducida = p.n1.toString()+p.n2.toString()+p.n3.toString()+p.n4.toString();

    if (PreferenciasUsuario().ultimaPagina != '' && passwordIntroducida != '') {
      await firestore.collection('Cuentalo').doc('Groups').collection(PreferenciasUsuario().ultimaPagina).doc('Info').set({
        'name' : PreferenciasUsuario().ultimaPagina,
        'password': passwordIntroducida
      });


      if (auth != null) {
      await firestore.collection('Cuentalo').doc('Users').collection(auth.currentUser!.email!).doc('Groups').update({
        PreferenciasUsuario().ultimaPagina : passwordIntroducida
      });

      context.go('/');
        
      }



    } else {

      showSnackBar(context, 'No debes dejar nada vacio');
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

  cleanPassword(){
    password.n1 = -1;
    password.n2 = -1;
    password.n3 = -1;
    password.n4 = -1;
  }

}
