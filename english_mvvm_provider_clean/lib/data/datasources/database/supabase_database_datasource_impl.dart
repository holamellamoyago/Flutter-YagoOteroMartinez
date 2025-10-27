import 'dart:ffi';

import 'package:english_mvvm_provider_clean/config/database_constants.dart';
import 'package:english_mvvm_provider_clean/data/datasources/database/database_datasource.dart';
import 'package:english_mvvm_provider_clean/domain/entities/app_user.dart';
import 'package:english_mvvm_provider_clean/domain/entities/level.dart';
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
      DatabaseConstants.userName: user.name,
      DatabaseConstants.userEmail: user.photoURL,
      DatabaseConstants.userUsername: user.username,
      DatabaseConstants.userPhotoURL: user.image,
    });
  }

  List<AppUser> mapearUsers(List<Map<String, dynamic>> lista) {
    Iterator it = lista.iterator;
    List<AppUser> users = [];

    while (it.moveNext()) {
      Map<String, dynamic> map = it.current;
      users.add(
        AppUser(
          uid: map[DatabaseConstants.userUID] ?? "no uid",
          name: map[DatabaseConstants.userName] ?? "no name",
          photoURL: map[DatabaseConstants.userPhotoURL] ?? "no photo_url",
          username: map[DatabaseConstants.userUsername] ?? "no username",
          image: map[DatabaseConstants.userPhotoURL] ?? "",
          totalPoints: map[DatabaseConstants.userTotalPoints] ?? 999,
          createdAt: map[DatabaseConstants.userCreatedAt],
        ),
      );
    }

    return users;
  }

  List<Level> mapearLevels(List<Map<String, dynamic>> data){
    List<Level> levels = [];

    for (var i = 0; i < data.length; i++) {
      Map<String, dynamic> mapa = data[i];
      Level level = Level(id: mapa["id_level"], categoryID: mapa["category_id"] , name: mapa["name"]);
      levels.add(level);
    }

    return levels;
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
}
