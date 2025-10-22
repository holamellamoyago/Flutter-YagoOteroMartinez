import 'package:english_mvvm_provider_clean/domain/entities/app_user.dart';
import 'package:english_mvvm_provider_clean/domain/entities/level.dart';
import 'package:english_mvvm_provider_clean/domain/repositories/database_repository.dart';
import 'package:flutter/widgets.dart';

class UsersViewmodel extends ChangeNotifier {
  DatabaseRepository databaseRepository;

  UsersViewmodel(this.databaseRepository) {
    getGeneralTable();
  }

  bool isLoading = false;
  String error = "";
  List<AppUser> users = [];
  List<Level> levels = [];

  Future<void> getGeneralTable() async {
    isLoading = true;
    error = "";
    notifyListeners();

    try {
      users = await databaseRepository.getGeneralTable();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> manageUser(AppUser user) async {
    isLoading = true;
    error = "";
    notifyListeners();

    if (!await databaseRepository.isUserExisting(user.uid)) {
      saveUser(user);
    } else {
      // TODO Hacer usecase
    }
  }

  Future<void> saveUser(AppUser user) async {
    try {
      databaseRepository.saveUser(user);
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
