import 'package:english_mvvm_provider_clean/data/datasources/auth/auth_datasource.dart';
import 'package:english_mvvm_provider_clean/domain/entities/user.dart';
import 'package:english_mvvm_provider_clean/domain/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;

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
  Future<User> loginWithGoogle() {
    return remoteDatasource.loginWithGoogle();
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

  @override
  Future<User> createAccountEmailPassword(String email, String password) {
    return remoteDatasource.createAccountEmailPassword(email, password);
  }
}
