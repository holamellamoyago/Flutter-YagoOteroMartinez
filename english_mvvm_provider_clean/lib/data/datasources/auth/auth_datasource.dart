import 'package:english_mvvm_provider_clean/domain/entities/app_user.dart';
// import 'package:firebase_auth/firebase_auth.dart' ;

abstract class AuthDatasource {
  Future<AppUser> getCurrentUser();
  Future<AppUser> loginWithEmail(String email, String password);
  Future<AppUser> loginWithGoogle();
  Future<void> logout();
  bool isLoggedIn();
  Future<AppUser> createAccountEmailPassword(String email, String password);
  Future<AppUser> loginAnonimously();
}
