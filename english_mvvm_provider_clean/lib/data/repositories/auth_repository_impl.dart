import 'package:english_mvvm_provider_clean/data/datasources/auth/auth_datasource.dart';
import 'package:english_mvvm_provider_clean/domain/entities/app_user.dart';
import 'package:english_mvvm_provider_clean/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDatasource remoteDatasource;
  AuthRepositoryImpl({required this.remoteDatasource});

  @override
  bool isLoggedIn() {
    return remoteDatasource.isLoggedIn();
  }

  @override
  Future<AppUser> loginWithEmail(String email, String password) {
    return remoteDatasource.loginWithEmail(email, password);
  }

  @override
  Future<AppUser> getCurrentUser() {
    return remoteDatasource.getCurrentUser();
  }

  @override
  Future<AppUser> loginWithGoogle() {
    return remoteDatasource.loginWithGoogle();
  }

  @override
  Future<void> logout() async {
    remoteDatasource.logout();
  }

  @override
  Future<AppUser> createAccountEmailPassword(String email, String password) {
    return remoteDatasource.createAccountEmailPassword(email, password);
  }

  @override
  Future<AppUser> loginAnonimously() {
    return remoteDatasource.loginAnonimously();
  }
}
