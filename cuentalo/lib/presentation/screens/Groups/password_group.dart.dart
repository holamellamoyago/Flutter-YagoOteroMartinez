import 'package:cuentalo/config/Group/group_auth.dart';
import 'package:cuentalo/config/preferences/pref_password.dart';
import 'package:cuentalo/presentation/screens.dart';
import 'package:flutter/gestures.dart';

class JoinPassword extends StatefulWidget {
  static const routename = '/joinPassword';
  const JoinPassword({super.key});

  @override
  State<JoinPassword> createState() => _JoinPasswordState();
}

class _JoinPasswordState extends State<JoinPassword> {
  TextEditingController passwordController = TextEditingController();
  final password = PreferenciasPassword();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const TitleLargeCustom(titulo: 'Cuéntalo'),
        ),
        body: const PanelPassword());
  }


}

class PanelPassword extends StatefulWidget {
  const PanelPassword({super.key});

  @override
  State<PanelPassword> createState() => _PanelPasswordState();
}

class _PanelPasswordState extends State<PanelPassword> {
  @override
  void initState() {
    super.initState();
  }

  final password = PreferenciasPassword();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PaddingCustom(
            height: 2.h,
          ),
          const TitleMediumCustom(
            titulo: 'Contraseña del grupo',
            align: TextAlign.start,
          ),
          const BodyCustom(
              titulo: 'Debes introducir una contraseña para el grupo'),
          PaddingCustom(
            height: 2.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              circleSmall(
                password.n1,
              ),
              PaddingCustom(
                width: 1.w,
              ),
              circleSmall(
                password.n2,
              ),
              PaddingCustom(
                width: 1.w,
              ),
              circleSmall(
                password.n3,
              ),
              PaddingCustom(
                width: 1.w,
              ),
              circleSmall(
                password.n4,
              ),
            ],
          ),
          PaddingCustom(
            height: 2.h,
          ),
          SizedBox(
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 3,
              mainAxisSpacing: 2.h,
              crossAxisSpacing: 2.w,
              padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 10.w),
              children: [
                numberGroupPassword(1),
                numberGroupPassword(2),
                numberGroupPassword(3),
                numberGroupPassword(4),
                numberGroupPassword(5),
                numberGroupPassword(6),
                numberGroupPassword(7),
                numberGroupPassword(8),
                numberGroupPassword(9),
                const ClipRRect(),
                numberGroupPassword(0),
                const ClipRRect()
              ],
            ),
          ),
          PaddingCustom(
            height: 4.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                  onTap: () => setState(() {
                        GroupAuth().borrarnumero();
                      }),
                  child: const Text(
                    'Borrar',
                    textAlign: TextAlign.end,
                  )),
            ],
          ),
        ],
      ),
    );
  }

  Widget numberGroupPassword(valor) {
    return GestureDetector(
      onTap: () => setState(() {
        GroupAuth().sumarContador(context, valor);
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

  Widget circleSmall(numero) {
    return AnimatedContainer(
      height: 2.h,
      width: 2.h,
      duration: Durations.extralong1,
      decoration: BoxDecoration(
          border: Border.all(),
          color: numero != -1 ? Colors.grey : Colors.transparent,
          borderRadius: BorderRadius.circular(100)),
    );
  }
}
