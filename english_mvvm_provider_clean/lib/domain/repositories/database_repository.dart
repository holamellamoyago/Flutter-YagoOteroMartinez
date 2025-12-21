import 'package:english_mvvm_provider_clean/domain/entities/app_user.dart';
import 'package:english_mvvm_provider_clean/domain/entities/level.dart';
import 'package:english_mvvm_provider_clean/domain/entities/level_category.dart';

abstract class DatabaseRepository {
  Future<List<AppUser>> getGeneralTable();
  Future<void> saveUser(AppUser user);
  Future<bool> isUserExisting(String uid);
  Future<List<Level>> getLevels();
  Future<List<LevelCategory>> getLevelCategory();
  Future<Map<int, bool>> getLevelsCompleted(String userUID);

  // 21-12-25
  // Actualización: quiero que mi app registro cuando los niveles se completan
  // y los puntos ganados que pueden variables dependiendo de aciertos / fallos
  Future<void> setLevelCompleted(int idLevel, String userUID);
  Future<void> setNewPoints(int currentPoints, String uid);

}
