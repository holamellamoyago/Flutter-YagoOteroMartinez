import 'package:cuentalo/presentation/screens.dart';

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
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const TitleLargeCustom(
                  titulo: 'Crea un nuevo grupo',
                  align: TextAlign.center,
                ),
                TextFieldCustom(
                  controller: nameController,
                  label: 'Nombre del grupo',
                  ocultacion: false,
                ),
                PaddingCustom(
                  height: 2.h,
                ),
                FilledButton(
                    onPressed: () async {
                      PreferenciasUsuario().ultimaPagina = nameController.text;
                      if (nameController.text != '') {
                        GroupAuth().cleanPassword();
                        context.push('/createGroupPassword');
                      } else {
                        showSnackBar(context, 'Introduce un nombre de grupo');
                      }
                    },
                    child: const Text('Pasar a la contraseña'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
