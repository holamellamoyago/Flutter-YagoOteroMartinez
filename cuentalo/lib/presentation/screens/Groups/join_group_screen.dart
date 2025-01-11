
import 'package:cuentalo/presentation/screens.dart';


class JoinScreen extends StatefulWidget {
  static const routename = '/join';
  const JoinScreen({super.key});

  @override
  State<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
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
          TitleLargeCustom(titulo: 'Unirse a un grupo'),
          TextFieldCustom(
              controller: nameController,
              label: 'Introduce el nombre del grupo',
              ocultacion: false),
          FilledButton(
              onPressed: () async {
                print('1'+nameController.text);
                await buscarGrupo(context, nameController);
              },
              child: Icon(Icons.arrow_right_alt))
        ],
      ),
    );
  }

  buscarGrupo(BuildContext context, nameController) async {
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
          
        } else{ 
          showSnackBar(context, 'No se encontro el grupo');
        }

    
  }
}
