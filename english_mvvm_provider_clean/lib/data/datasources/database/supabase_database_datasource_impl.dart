import 'package:english_mvvm_provider_clean/config/database_constants.dart';
import 'package:english_mvvm_provider_clean/data/datasources/database/database_datasource.dart';
import 'package:english_mvvm_provider_clean/domain/entities/app_user.dart';
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
          uid: map[DatabaseConstants.userUID],
          name: map[DatabaseConstants.userName],
          photoURL: map[DatabaseConstants.userPhotoURL],
          username: map[DatabaseConstants.userUsername],
          image: map[DatabaseConstants.userPhotoURL] ?? "",
          totalPoints: map[DatabaseConstants.userTotalPoints],
          createdAt: map[DatabaseConstants.userCreatedAt],
        ),
      );
    }

    return users;
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

}
