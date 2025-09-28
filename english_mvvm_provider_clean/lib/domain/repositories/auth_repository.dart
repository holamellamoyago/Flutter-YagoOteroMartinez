import 'package:english_mvvm_provider_clean/domain/entities/user.dart';

abstract class AuthRepository {
  Future<User?> getCachedUser();
  Future<void> setCachedUser();
  Future<void> cleanCache();
  Future<User> getCurrentUser();
  Future<User> loginWithEmail();
  Future<User> loginWithGoogle();
  Future<void> logout();
  bool isLoggedIn();
}
