import 'package:english_mvvm_provider_clean/domain/entities/app_user.dart';

abstract class SocialDatasource {
  Future<List<AppUser>> getGeneralTable();
}
