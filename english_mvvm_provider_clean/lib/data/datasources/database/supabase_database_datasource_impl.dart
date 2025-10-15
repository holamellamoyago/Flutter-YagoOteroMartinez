import 'package:english_mvvm_provider_clean/data/datasources/database/database_datasource.dart';
import 'package:english_mvvm_provider_clean/data/strings/app_strings.dart';
import 'package:english_mvvm_provider_clean/domain/entities/app_user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseDatabaseDatasourceImpl extends DatabaseDatasource {
  SupabaseClient supabase = Supabase.instance.client;
  AppStrings str = AppStrings();

  @override
  Future<List<AppUser>> getGeneralTable() async {
    final data = await supabase.from(AppStrings.tableUsers).select();

    if (data.isNotEmpty) {
      return mapearUsers(data);
    } else {
      return List<AppUser>.empty();
    }
  }

  @override
  Future<void> saveUser(AppUser user) async {
    await supabase.from(AppStrings.tableUsers).insert({
      'name': user.name,
      'email': user.email,
      'username': user.username,
      'photo_url': user.image,
    });
  }

  List<AppUser> mapearUsers(List<Map<String, dynamic>> lista) {
    Iterator it = lista.iterator;
    List<AppUser> users = [];

    while (it.moveNext()) {
      Map<String, dynamic> map = it.current;
      users.add(
        AppUser(
          name: map["name"],
          email: map["email"],
          username: map["username"],
          image: map["photo_url"],
          totalPoints: map["total_puntos"],
          createdAt: map["created_at"],
        ),
      );
    }

    return users;
  }
}
