
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuentalo/config/preferences/pref_usuarios.dart';
import 'package:cuentalo/presentation/widgets/widgets_standart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';


class HomeScreen extends StatelessWidget {
  static const routeName = '/';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 11.h),
        child: const AppBarCustom(),
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        children: [
          FloatingActionButton.small(
            heroTag: null,
            child: const Icon(Icons.add),
            onPressed: () {
              context.push('/creadorGrupo');
            },
          ),
          FloatingActionButton.small(
            heroTag: null,
            child: const Icon(Icons.arrow_right),
            onPressed: () {
              context.push('/join');
            },
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BodyCustom(titulo: '¿Todavía no tienes ningún grupo añadido? '),
            ListaGrupos()
          ],
        ),
      ),
    );
  }
}

class AppBarCustom extends StatelessWidget {
  const AppBarCustom({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
          child: AppBar(
            centerTitle: true,
            title: const TitleLargeCustom(titulo: 'Cuéntalo'),
            actions: [
              IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.person_2_outlined))
            ],
          ),
        ),
      ),
    );
  }
}

class ListaGrupos extends StatelessWidget {
  const ListaGrupos({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance.currentUser!;
    return SizedBox(
      height: 40.h,
      child: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('Cuentalo')
            .doc('Users')
            .collection(auth.email!)
            .doc('Groups')
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error al cargar los datos"));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text("El documento no existe"));
          }
      
          final data = snapshot.data!.data() as Map<String, dynamic>;
      
          return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final fieldName = data.keys.elementAt(index);
                // final fieldValue = data[fieldName];
      
                return fieldName == 'a' ? SizedBox() : ListTile(
                  onTap: () {
                    var prefs = PreferenciasUsuario();
                    prefs.nombreGrupo = fieldName;
                    showSnackBar(context, prefs.nombreGrupo);
                    context.push('/group');
                  },
                  title: Text(fieldName),
                  leading: Icon(Icons.label),
                );
              });
        },
      ),
    );
  }
}
