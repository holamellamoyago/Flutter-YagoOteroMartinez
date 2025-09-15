import 'package:flutter/widgets.dart';
import 'package:provider_mvvm_app/data/repositories/user_repository.dart';
import 'package:provider_mvvm_app/models/user.dart';

class UsersViewmodel extends ChangeNotifier {
  UserRepository repository;
  
  UsersViewmodel(this.repository){
    loadUsers();
  }

  List<User> users = [];
  bool loading = false;
  String? error;

  Future<void> loadUsers() async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      users = await repository.getUsers();
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> addUser(User user) async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      await repository.addUser(user);
      users = await repository.getUsers();
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  // Future<List<User>> get _users => users.getUsers();
}
