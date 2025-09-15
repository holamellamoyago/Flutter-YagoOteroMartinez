import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_mvvm_app/data/datasources/local_user_datasource.dart';
import 'package:provider_mvvm_app/data/repositories/user_repository.dart';
import 'package:provider_mvvm_app/view/list_users.dart';
import 'package:provider_mvvm_app/viewmodel/apptheme_viewmodel.dart';
import 'package:provider_mvvm_app/viewmodel/users_viewmodel.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppthemeViewmodel()),
        ChangeNotifierProvider(
          create: (context) => UsersViewmodel(
            UserRepositoryImplementation(InMemoryDatasource()),
          ),
        ),
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
        body: Column(children: [Expanded(child: UsersList())]),
      ),
    );
  }
}
