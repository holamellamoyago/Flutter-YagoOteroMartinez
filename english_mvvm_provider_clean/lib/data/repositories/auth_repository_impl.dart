import 'package:english_mvvm_provider_clean/data/datasources/auth/auth_datasource.dart';
import 'package:english_mvvm_provider_clean/data/datasources/database/database_datasource.dart';
import 'package:english_mvvm_provider_clean/domain/entities/app_user.dart';
import 'package:english_mvvm_provider_clean/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDatasource firebaseDatasource;
  final DatabaseDatasource databaseDatasource;
  AuthRepositoryImpl({
    required this.firebaseDatasource,
    required this.databaseDatasource,
  });

  @override
  bool isLoggedIn() {
    return firebaseDatasource.isLoggedIn();
  }

  @override
  Future<AppUser> loginWithEmail(String email, String password) {
    return firebaseDatasource.loginWithEmail(email, password);
  }

  @override
  Future<AppUser> getCurrentUser() {
    return firebaseDatasource.getCurrentUser();
  }

  @override
  Future<AppUser> loginWithGoogle() async {
    AppUser user = await firebaseDatasource.loginWithGoogle();

    return user;
  }

  @override
  Future<void> logout() async {
    firebaseDatasource.logout();
  }

  @override
  Future<AppUser> createAccountEmailPassword(
    String email,
    String password,
  ) async {
    AppUser user = await firebaseDatasource.createAccountEmailPassword(
      email,
      password,
    );

    return user;
  }

  @override
  Future<AppUser> loginAnonimously() {
    return firebaseDatasource.loginAnonimously();
  }
}
