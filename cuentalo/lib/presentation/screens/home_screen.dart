
import 'dart:math';

import 'package:cuentalo/presentation/screens.dart';



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
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text('Tus grupos', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),)
                ],
              ),
              const ListaGrupos()
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
    return Expanded(
      child: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('Cuentalo')
            .doc('Users')
            .collection(auth.email!)
            .doc('Groups')
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Error al cargar los datos"));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("El documento no existe"));
          }
      
          final data = snapshot.data!.data() as Map<String, dynamic>;
      
          return ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 1.h),
              itemCount: data.length,
              itemBuilder: (context, index) {
                final fieldName = data.keys.elementAt(index);
                // final fieldValue = data[fieldName];
      
                return fieldName == 'a' ? const SizedBox() : Container(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 1.h),
                    child: Container(
                      decoration: BoxDecoration(color: Colors.grey[400],borderRadius: BorderRadius.all(Radius.circular(10)) , boxShadow: [BoxShadow(offset: Offset(4, 4))]),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          onTap: () {
                            var prefs = PreferenciasUsuario();
                            prefs.nombreGrupo = fieldName;
                            context.push('/group');
                          },
                          title: Text(fieldName),
                          leading: ClipRRect(
                            borderRadius: const BorderRadius.all(Radius.circular(100)),
                            child: Image.asset('assets/logo.png'),),
                          trailing: const Icon(Icons.arrow_forward_outlined),
                        ),
                      ),
                    ),
                  ),
                );
              });
        },
      ),
    );
  }
}
