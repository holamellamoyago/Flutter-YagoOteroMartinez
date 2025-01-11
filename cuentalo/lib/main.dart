import 'package:cuentalo/config/preferences/pref_password.dart';
import 'package:cuentalo/config/preferences/pref_usuarios.dart';
import 'package:cuentalo/config/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';



void main() async {
    WidgetsFlutterBinding.ensureInitialized();

  await PreferenciasUsuario.init();
  await PreferenciasPassword.init();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) => MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: appRouter,
      ),
    );
  }
}
