// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:english_mvvm_provider_clean/data/viewmodel/auth_viewmodel.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AuthViewmodel authProvider = Provider.of<AuthViewmodel>(
      context,
      listen: false,
    );

    var lista = [
      ListTile(title: Text("Log out"), onTap: () => authProvider.logOut()),
    ];

    return Scaffold(body: ListView(children: lista));
  }
}
