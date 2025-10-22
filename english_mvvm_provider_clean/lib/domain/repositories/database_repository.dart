import 'package:english_mvvm_provider_clean/domain/entities/app_user.dart';
import 'package:english_mvvm_provider_clean/domain/entities/level.dart';

abstract class DatabaseRepository {
  Future<List<AppUser>> getGeneralTable();
  Future<void> saveUser(AppUser user);
  Future<bool> isUserExisting(String uid);
    Future<List<Level>> getLevels();
  
}
