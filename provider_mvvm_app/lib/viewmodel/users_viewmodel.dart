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

    /* 
      1. En este trozo de código hago que el loading se active para el Circular
      2. Pongo error a null para eliminar posibles anteriores errores
      3. notify para que se recargue el Widget y salga el Circular.. 
    
    */
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
}
