// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:english_mvvm_provider_clean/data/viewmodel/auth_viewmodel.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorSeed = Theme.of(context).colorScheme;

    AuthViewmodel authProvider = Provider.of<AuthViewmodel>(
      context,
      listen: false,
    );

    var lista = [
      ListTile(
        trailing: Icon(Icons.exit_to_app, color: colorSeed.primary),
        title: Text("Log out"),
        subtitle: Text("Exit from the application"),
        onTap: () async {
          await authProvider.logOut();
        },
      ),
    ];

    return Scaffold(body: ListView(children: lista));
  }
}
