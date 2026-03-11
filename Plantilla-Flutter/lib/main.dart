import 'package:flutter/material.dart';
import 'package:plantilla_flutter/configure/router/app_router.dart';
import 'package:plantilla_flutter/presentation/screens.dart';


void main() async {
  await PreferenciasUsuario.init();
  await dotenv.load(fileName: ".env");
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
    );
  }
}
