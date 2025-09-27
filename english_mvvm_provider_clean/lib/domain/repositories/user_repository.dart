import 'package:english_mvvm_provider_clean/domain/entities/user.dart';

abstract class UserRepository {
  Future<User> getCurrentUser();
  Future<User> loginWithEmail();
  Future<User> loginWithGoogle();
  Future<void> logout();
  Future<bool> isLoogued();
}
