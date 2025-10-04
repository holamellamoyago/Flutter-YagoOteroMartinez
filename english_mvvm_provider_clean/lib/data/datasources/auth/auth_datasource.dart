import 'package:english_mvvm_provider_clean/domain/entities/user.dart';
// import 'package:firebase_auth/firebase_auth.dart' ;

abstract class AuthDatasource {
  Future<User?> getCachedUser();
  Future<void> setCachedUser();
  Future<void> cleanCache();
  Future<User> getCurrentUser();
  Future<User> loginWithEmail(String email, String password);
  Future<User> loginWithGoogle();
  Future<void> logout();
  bool isLoggedIn();
  Future<User> createAccountEmailPassword(String email, String password);
}
