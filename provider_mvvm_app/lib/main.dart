import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_mvvm_app/viewmodel/apptheme_viewmodel.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppthemeViewmodel()),
      ],
      child: MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    AppthemeViewmodel apptheme = Provider.of<AppthemeViewmodel>(context);
    return MaterialApp(
      theme: apptheme.appTheme,
      home: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton.filled(
              icon: Icon(Icons.mode_night_outlined),
              onPressed: () => apptheme.changeTheme(),
            ),
          ],
        ),
        body: Center(child: Text('Hello World!')),
      ),
    );
  }
}
