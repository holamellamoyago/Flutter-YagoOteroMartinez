import 'package:english_mvvm_provider_clean/data/viewmodel/levels_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LevelsScreen extends StatelessWidget {
  const LevelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    LevelsViewmodel provider = Provider.of<LevelsViewmodel>(
      context,
      listen: true,
    );

    return Scaffold(
      appBar: AppBar(title: Text("Levels"), centerTitle: true),
      body: Column(
        children: [
          Text("Niveles"),

          Expanded(
            child: provider.levels.isEmpty
                ? Center(child: Text("No hay datos"))
                : ListView.builder(
                    itemCount: provider.levels.length,
                    itemBuilder: (context, i) => ListTile(
                      title: Text(
                        provider.levels[i].name,
                        style: TextStyle(color: Colors.black),
                      )
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
