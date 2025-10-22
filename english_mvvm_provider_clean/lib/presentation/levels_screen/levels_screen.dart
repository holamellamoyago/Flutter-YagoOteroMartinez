import 'package:english_mvvm_provider_clean/data/viewmodel/levels_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LevelsScreen extends StatelessWidget {
  const LevelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    LevelsViewmodel provider = Provider.of<LevelsViewmodel>(
      context,
      listen: false,
    );

    return Scaffold(
      appBar: AppBar(title: Text("Levels"), centerTitle: true),
      body: Center(
        child: FilledButton(
          style: ButtonStyle(
            // backgroundColor: WidgetStateProperty.all(Colors.red),
          ),
          onPressed: () => provider.loadLevels(),
          child: Text("Mostrar"),
        ),
      ),
    );
  }
}
