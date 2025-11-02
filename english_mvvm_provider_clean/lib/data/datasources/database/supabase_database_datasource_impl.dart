import 'package:english_mvvm_provider_clean/config/database_constants.dart';
import 'package:english_mvvm_provider_clean/data/datasources/database/database_datasource.dart';
import 'package:english_mvvm_provider_clean/data/viewmodel/users_viewmodel.dart';
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
      DatabaseConstants.userUID: user.uid,
      DatabaseConstants.globalName: user.name,
      DatabaseConstants.userEmail: user.photoURL,
      DatabaseConstants.userUsername: user.username,
      DatabaseConstants.userPhotoURL: user.image,
    });
  }

  @override
  Future<bool> isUserExisting(String uid) async {
    try {
      final data = await _supabase
          .from(DatabaseConstants.tableUsers)
          .select()
          .eq(DatabaseConstants.userUID, uid)
          .maybeSingle();
      return data != null;
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

    print(data);

    return Map<int,bool>();
  }
}
