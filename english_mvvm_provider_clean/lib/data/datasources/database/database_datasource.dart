import 'package:english_mvvm_provider_clean/domain/entities/app_user.dart';
import 'package:english_mvvm_provider_clean/domain/entities/level.dart';
import 'package:english_mvvm_provider_clean/domain/entities/level_category.dart';

abstract class DatabaseDatasource {
  Future<List<AppUser>> getGeneralTable();
  Future<void> saveUser(AppUser user);
  Future<bool> isUserExisting(String uid);
  Future<List<Level>> getLevels();
  Future<List<LevelCategory>> getLevelCategory();
  // int: level_id , bool: completed
  Future<Map<int, bool>> getLevelsCompleted(String userUID);

  // Actualización 21/12
  Future<void> setLevelCompleted(int idLevel, String userUID);
  Future<void> setNewPoints(int currentPoints, String uid);

}
