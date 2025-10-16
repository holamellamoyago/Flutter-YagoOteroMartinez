import 'package:english_mvvm_provider_clean/domain/entities/app_user.dart';

abstract class DatabaseDatasource {
  Future<List<AppUser>> getGeneralTable();
  Future<void> saveUser(AppUser user);
  Future<bool> isUserExisting(String uid);
}
