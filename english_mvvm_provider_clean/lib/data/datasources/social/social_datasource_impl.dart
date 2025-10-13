import 'package:english_mvvm_provider_clean/data/datasources/social/social_datasource.dart';
import 'package:english_mvvm_provider_clean/domain/entities/app_user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SocialDatasourceImpl extends SocialDatasource {
  Supabase supabase = Supabase.instance;

  @override
  Future<List<AppUser>> getGeneralTable() async {
    final data = await supabase.client.from('users').select();

    if (data.isNotEmpty) {
      return mapearUsers(data);
    } else {
      return List<AppUser>.empty();
    }
  }

  List<AppUser> mapearUsers(List<Map<String, dynamic>> lista) {
    Iterator it = lista.iterator;
    List<AppUser> users = [];

    while (it.moveNext()) {
      Map<String, dynamic> map = it.current;
      map["photo_url"] != null
          ? users.add(
              AppUser(
                name: map["name"],
                email: map["email"],
                image: map["photo_url"],
              ),
            )
          : users.add(AppUser(name: map["name"], email: map["email"]));
    }

    return users;
  }
}
