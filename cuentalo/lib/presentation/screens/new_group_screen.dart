
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuentalo/presentation/widgets/widgets_standart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
class CreadorGrupos extends StatefulWidget {
  static const routename = '/creadorGrupo';
  const CreadorGrupos({super.key});

  @override
  State<CreadorGrupos> createState() => _CreadorGruposState();
}

class _CreadorGruposState extends State<CreadorGrupos> {
TextEditingController nameController = TextEditingController();

TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
      child: Form(
        child: Padding(
            padding:  EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TitleLargeCustom(titulo: 'Crea un nuevo grupo', align: TextAlign.center,),
              TextFieldCustom(controller: nameController, label: 'Nombre del grupo', ocultacion: false,),
              PaddingCustom(height: 2.h,),
              TextFieldCustom(controller: passwordController, label: 'Contraseña del grupo', ocultacion: true,),
              PaddingCustom(height: 2.h,),
              FilledButton(onPressed: () async {
                await crearGrupo(nameController, passwordController);
              }, child: Text('Crear grupo'))
            ],
          ),
        ),
      ),
    ),
    );
  }
  crearGrupo(nameController , passwordController) async {
    final firestore = FirebaseFirestore.instance;
    final FirebaseAuth auth = FirebaseAuth.instance;
    if (nameController.text != '' && passwordController.text != '') {
      await firestore.collection('Cuentalo').doc('Gruoups').collection(nameController.text).doc('Info').set({
        'name' : nameController.text,
        'password': passwordController.text
      });


      if (auth != null) {
      await firestore.collection('Cuentalo').doc('Users').collection(auth.currentUser!.email!).doc('Groups').update({
        nameController.text : passwordController.text
      });

      context.pushReplacement('/');
        
      }



    } else {

      showSnackBar(context, 'No debes dejar nada vacio');
    }
  }
}