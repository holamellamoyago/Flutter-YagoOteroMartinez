import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_mvvm_app/viewmodel/users_viewmodel.dart';

class UsersList extends StatelessWidget {
  const UsersList({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UsersViewmodel>();
    
    return provider.loading
        ? CircularProgressIndicator()
        : provider.error != null
        ? Text(provider.error!)
        : ListView.builder(
            itemCount: provider.users.length,
            itemBuilder: (context, index) =>
                Text(provider.users[index].username),
          );
  }
}
