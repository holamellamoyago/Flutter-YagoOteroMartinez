import 'package:english_mvvm_provider_clean/domain/entities/user.dart';

abstract class UserRepositoryImpl {
  Future<User> getCurrentUser();
  Future<User> loginWithEmail();
  Future<User> loginWithGoogle();
  Future<void> logout();
  Future<bool> isLoggedIn();
}
