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
        body: const PanelPassword(isCreating: false,));
  }


}


