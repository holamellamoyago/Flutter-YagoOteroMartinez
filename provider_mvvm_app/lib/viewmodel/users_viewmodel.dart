import 'package:flutter/widgets.dart';
import 'package:provider_mvvm_app/domain/entities/user.dart';
import 'package:provider_mvvm_app/domain/repositories/user_repository.dart';
import 'package:provider_mvvm_app/domain/usecases/get_users.dart';

class UsersViewmodel extends ChangeNotifier {
  GetUsers getUsers;
  
  UsersViewmodel(this.getUsers){
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
      users = await getUsers();
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  // Future<void> addUser(User user) async {
  //   loading = true;
  //   error = null;
  //   notifyListeners();

  //   try {
  //     await getUsers.addUser(user);
  //     users = await getUsers.getUsers();
  //   } catch (e) {
  //     error = e.toString();
  //   } finally {
  //     loading = false;
  //     notifyListeners();
  //   }
  // }
}
