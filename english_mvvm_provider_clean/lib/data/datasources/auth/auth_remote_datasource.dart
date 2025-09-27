import 'package:english_mvvm_provider_clean/data/datasources/auth/local_user_datasource.dart';
import 'package:english_mvvm_provider_clean/domain/entities/user.dart';

class AuthRemoteDatasource implements LocalUserDatasource {
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
  Future<bool> isLoggedIn() {
    // TODO: implement isLoggedIn
    throw UnimplementedError();
  }

  @override
  Future<User> loginWithEmail() {
    // TODO: implement loginWithEmail
    throw UnimplementedError();
  }

  @override
  Future<User> loginWithGoogle() {
    // TODO: implement loginWithGoogle
    throw UnimplementedError();
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