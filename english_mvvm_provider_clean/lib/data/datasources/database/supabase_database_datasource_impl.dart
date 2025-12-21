import 'package:english_mvvm_provider_clean/config/database_constants.dart';
import 'package:english_mvvm_provider_clean/data/datasources/database/database_datasource.dart';
import 'package:english_mvvm_provider_clean/domain/entities/app_user.dart';
import 'package:english_mvvm_provider_clean/domain/entities/level.dart';
import 'package:english_mvvm_provider_clean/domain/entities/level_category.dart';
import 'package:english_mvvm_provider_clean/utils/map_objects.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseDatabaseDatasourceImpl extends DatabaseDatasource {
  final SupabaseClient _supabase = Supabase.instance.client;

  @override
  Future<List<AppUser>> getGeneralTable() async {
    final data = await _supabase
        .from(DatabaseConstants.tableUsers)
        .select()
        .order(DatabaseConstants.userTotalPoints);

    if (data.isNotEmpty) {
      return mapearUsers(data);
    } else {
      return List<AppUser>.empty();
    }
  }

  @override
  Future<void> saveUser(AppUser user) async {
    await _supabase.from(DatabaseConstants.tableUsers).insert({
      DatabaseConstants.uidUser: user.uid,
      DatabaseConstants.globalName: user.name,
      DatabaseConstants.userEmail: user.photoURL,
      DatabaseConstants.userUsername: user.username,
      DatabaseConstants.userPhotoURL: user.image,
    });
  }

  @override
  Future<bool> isUserExisting(String uid) async {
    try {
      final List<Map<String, dynamic>> data = await _supabase
          .from(DatabaseConstants.tableUsers)
          .select()
          .eq(DatabaseConstants.uidUser, uid);

      if (data.isNotEmpty) {
        return true;
      }

      return false;
    } catch (e) {
      throw Exception("Error checking user existence: $e");
    }
  }

  @override
  Future<List<Level>> getLevels() async {
    List<Map<String, dynamic>> data = await _supabase
        .from(DatabaseConstants.tableLevels)
        .select();

    return mapearLevels(data);
  }

  @override
  Future<List<LevelCategory>> getLevelCategory() async {
    List<Map<String, dynamic>> data = await _supabase
        .from(DatabaseConstants.tableLevelCategory)
        .select(
          '${DatabaseConstants.idCategoria},${DatabaseConstants.globalName}',
        );

    return mapearLevelCategories(data);
  }

  @override
  Future<Map<int, bool>> getLevelsCompleted(String userUID) async {
    List<Map<String, dynamic>> data = await _supabase
        .from(DatabaseConstants.tableLevelsUsers)
        .select()
        .eq(DatabaseConstants.userUID, userUID);

    return mapLevelsCompleted(data);
  }

  @override
  Future<void> setLevelCompleted(int idLevel, String userUID) async {
    await _supabase.from(DatabaseConstants.tableLevelsUsers).upsert({
      DatabaseConstants.levelID: idLevel,
      DatabaseConstants.userUID: userUID,
      DatabaseConstants.levelCompleted: true,
    });
  }

  @override
  Future<void> setNewPoints(int currentPoints, String uid) async {
    await _supabase.from(DatabaseConstants.tablePoints).insert({
      DatabaseConstants.userUID: uid,
      DatabaseConstants.columnPoints: currentPoints,
    });
  }
}
