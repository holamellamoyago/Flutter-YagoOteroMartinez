import 'package:english_mvvm_provider_clean/domain/entities/app_user.dart';

abstract class SocialRepository {
 Future<List<AppUser>> getGeneralTable();
}
