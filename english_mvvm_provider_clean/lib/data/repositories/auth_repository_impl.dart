import 'package:english_mvvm_provider_clean/data/datasources/auth/auth_datasource.dart';
import 'package:english_mvvm_provider_clean/domain/entities/user.dart';
import 'package:english_mvvm_provider_clean/domain/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;

class AuthRepositoryImpl implements AuthRepository {
  final AuthDatasource datasource;
  AuthRepositoryImpl({required this.datasource});

  @override
  bool isLoggedIn() {
    return datasource.isLoggedIn();
  }

  @override
  Future<void> cleanCache() {
    // TODO: implement cleanCache
    throw UnimplementedError();
  }

  @override
  Future<User?> getCachedUser() {
    // TODO: implement getCachedUser
    throw UnimplementedError();
  }

  @override
  Future<User> getCurrentUser() {
    // TODO: implement getCurrentUser
    throw UnimplementedError();
  }

  @override
  Future<User> loginWithEmail(String email, String password) {
    throw UnimplementedError();
  }

  @override
  Future<User> loginWithGoogle() {
    return datasource.loginWithGoogle();
  }

  @override
  Future<void> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<void> setCachedUser() {
    // TODO: implement setCachedUser
    throw UnimplementedError();
  }
}
