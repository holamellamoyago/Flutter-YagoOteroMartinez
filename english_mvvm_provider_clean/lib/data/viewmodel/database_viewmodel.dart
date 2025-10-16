import 'package:english_mvvm_provider_clean/domain/entities/app_user.dart';
import 'package:english_mvvm_provider_clean/domain/repositories/database_repository.dart';
import 'package:flutter/widgets.dart';

class DatabaseViewmodel extends ChangeNotifier {
  DatabaseRepository databaseRepository;

  DatabaseViewmodel(this.databaseRepository) {
    getGeneralTable();
  }

  bool isLoading = false;
  String error = "";
  List<AppUser> users = [];

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

  Future<void> saveUser(AppUser user) async {
    isLoading = true;
    error = "";
    notifyListeners();

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
