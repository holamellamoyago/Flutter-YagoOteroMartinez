
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuentalo/config/preferences/pref_usuarios.dart';
import 'package:cuentalo/presentation/widgets/widgets_standart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class JoinPassword extends StatefulWidget {
  static const routename = '/joinPassword';
  const JoinPassword({super.key});

  @override
  State<JoinPassword> createState() => _JoinPasswordState();
}

class _JoinPasswordState extends State<JoinPassword> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const TitleLargeCustom(titulo: 'Cuéntalo'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const TitleLargeCustom(titulo: 'Contraseña del grupo'),
          TextFieldCustom(
              controller: passwordController,
              label: 'Introduce la contraseña del grupo',
              ocultacion: false),
          FilledButton(
              onPressed: () async {
                print('1' + nameController.text);
                comprobarContrasena(nameController, passwordController);
              },
              child: const Icon(Icons.arrow_right_alt))
        ],
      ),
    );
  }

  comprobarContrasena(nameController, passwordController) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final FirebaseAuth auth = FirebaseAuth.instance;
    final prefs = PreferenciasUsuario();

    try {
      final DocumentSnapshot future = await firestore
          .collection('Cuentalo')
          .doc('Gruoups')
          .collection(prefs.ultimaPagina)
          .doc('Info')
          .get();

      if (future.exists) {
        final String password = future['password'];

        if (passwordController.text == password) {
          try {
            await firestore
                .collection('Cuentalo')
                .doc('Users')
                .collection(auth.currentUser!.email!)
                .doc('Groups')
                .update({prefs.ultimaPagina: passwordController.text});
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
}
