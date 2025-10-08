import 'package:english_mvvm_provider_clean/data/datasources/auth/auth_datasource.dart';
import 'package:english_mvvm_provider_clean/domain/entities/user.dart';
import 'package:english_mvvm_provider_clean/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDatasource remoteDatasource;
  AuthRepositoryImpl({required this.remoteDatasource});

  @override
  bool isLoggedIn() {
    return remoteDatasource.isLoggedIn();
  }

  @override
  Future<User> loginWithEmail(String email, String password) {
    return remoteDatasource.loginWithEmail(email, password);
  }

  @override
  Future<User> getCurrentUser() {
    return remoteDatasource.getCurrentUser();
  }

  @override
  Future<User> loginWithGoogle() {
    return remoteDatasource.loginWithGoogle();
  }

  @override
  Future<void> logout() async {
    remoteDatasource.logout();
  }

  @override
  Future<User> createAccountEmailPassword(String email, String password) {
    return remoteDatasource.createAccountEmailPassword(email, password);
  }

  @override
  Future<User> loginAnonimously() {
    return remoteDatasource.loginAnonimously();
  }
}
