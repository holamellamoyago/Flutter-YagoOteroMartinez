import 'package:english_mvvm_provider_clean/config/database_constants.dart';
import 'package:english_mvvm_provider_clean/data/datasources/database/database_datasource.dart';
import 'package:english_mvvm_provider_clean/data/strings/app_strings.dart';
import 'package:english_mvvm_provider_clean/domain/entities/app_user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseDatabaseDatasourceImpl extends DatabaseDatasource {
  SupabaseClient supabase = Supabase.instance.client;
  AppStrings str = AppStrings();

  @override
  Future<List<AppUser>> getGeneralTable() async {
    final data = await supabase
        .from(AppStrings.tableUsers)
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
    await supabase.from(DatabaseConstants.tableUsers).insert({
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
          photoURL: map[DatabaseConstants.userEmail],
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
    var data = await supabase.from(AppStrings.tableUsers).select().match({
      DatabaseConstants.userUID: uid,
    });

    if (data.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }
}
