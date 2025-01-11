
import 'package:cuentalo/config/Group/group_auth.dart';
import 'package:cuentalo/config/preferences/pref_password.dart';
import 'package:cuentalo/presentation/screens.dart';

class JoinPassword extends StatefulWidget {
  static const routename = '/joinPassword';
  const JoinPassword({super.key});

  @override
  State<JoinPassword> createState() => _JoinPasswordState();
}

class _JoinPasswordState extends State<JoinPassword> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final password = PreferenciasPassword();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const TitleLargeCustom(titulo: 'Cuéntalo'),
      ),
      body: PanelPassword()
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



class CirculoPequeno extends StatefulWidget {
  const CirculoPequeno({
    super.key,
    required this.numero,
  });

  final int numero;

  @override
  State<CirculoPequeno> createState() => _CirculoPequenoState();
}

class _CirculoPequenoState extends State<CirculoPequeno> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: 2.h,
      width: 2.h,
      duration: Durations.extralong1,
      decoration: BoxDecoration(
          border: Border.all(),
          color: widget.numero != -1 ? Colors.grey : Colors.transparent,
          borderRadius: BorderRadius.circular(100)),
    );
  }
}



class PanelPassword extends StatefulWidget {
  const PanelPassword({super.key});

  @override
  State<PanelPassword> createState() => _PanelPasswordState();
}

class _PanelPasswordState extends State<PanelPassword> {
    final password = PreferenciasPassword();

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const TitleLargeCustom(titulo: 'Contraseña del grupo'),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CirculoPequeno(
                numero: password.n1,
              ),
              CirculoPequeno(
                numero: password.n2,
              ),
              CirculoPequeno(
                numero: password.n3,
              ),
              CirculoPequeno(
                numero: password.n4,
              ),
            ],
          ),
          SizedBox(
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 3,
              mainAxisSpacing: 2.h,
              crossAxisSpacing: 2.w,
              padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 20.w),
              children: [
                const ClipRRect(),
                numberGroupPassword(
                   0,
                ),
                const ClipRRect()
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(onTap: () => setState(() {
                GroupAuth().borrarnumero();
              }), child: const Text('Borrar', textAlign: TextAlign.end,)),
            ],
          ),
          // FilledButton(
          //     onPressed: () async {
          //       print('1' + nameController.text);
          //       comprobarContrasena(nameController, passwordController);
          //     },
          //     child: const Icon(Icons.arrow_right_alt))
        ],
      );
  }

  Widget numberGroupPassword(valor){
    return GestureDetector(
      onTap: () => setState(() {
        GroupAuth().sumarContador(valor);
      }),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(100)),
        child: Container(
            width: 10,
            height: 10,
            color: Colors.red[200],
            child: Center(child: BodyCustom(titulo: valor.toString()))),
      ),
    );
  }
}

