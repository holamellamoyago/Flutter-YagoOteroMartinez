import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_mvvm_app/data/datasources/local_user_datasource.dart';
import 'package:provider_mvvm_app/data/repositories/user_repository_impl.dart';
import 'package:provider_mvvm_app/domain/usecases/get_users.dart';
import 'package:provider_mvvm_app/view/list_users.dart';
import 'package:provider_mvvm_app/viewmodel/apptheme_viewmodel.dart';
import 'package:provider_mvvm_app/viewmodel/users_viewmodel.dart';

void main() {
  final localUserDatasource = InMemoryDatasource();
  final userRepository = UserRepositoryImplementation(localUserDatasource);
  final getUsers = GetUsers(userRepository);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppthemeViewmodel()),
        ChangeNotifierProvider(create: (context) => UsersViewmodel(getUsers)),
      ],
      child: MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    AppthemeViewmodel apptheme = context.watch<AppthemeViewmodel>();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
