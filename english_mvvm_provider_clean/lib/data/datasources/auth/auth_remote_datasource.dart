import 'package:english_mvvm_provider_clean/data/datasources/auth/auth_datasource.dart';
import 'package:english_mvvm_provider_clean/domain/entities/user.dart'
    as app_user;
import 'package:firebase_auth/firebase_auth.dart' as firebase;

class AuthRemoteDatasource implements AuthDatasource {
  final firebase.FirebaseAuth _auth = firebase.FirebaseAuth.instance;

  // Hecho
  @override
  bool isLoggedIn() {
    bool isLoggin = false;
    _auth.userChanges().listen((firebase.User? user) {
      if (user != null) {
        isLoggin = true;
      }
    });

    return isLoggin;
  }

  @override
  Future<app_user.User> createAccountEmailPassword(
    String email,
    String password,
  ) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _firebaaseUserToAppUser(credential.user!);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<app_user.User> loginWithEmail(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return _firebaaseUserToAppUser(credential.user!);
    } catch (e) {
      throw Exception(e);
    }
  }
  // TODO Sin hacer


  @override
  Future<app_user.User> loginWithGoogle() async {
    throw UnimplementedError();
  }

  @override
  Future<void> cleanCache() {
    // TODO: implement cleanCache
    throw UnimplementedError();
  }

  @override
  Future<app_user.User?> getCachedUser() {
    // TODO: implement getCachedUser
    throw UnimplementedError();
  }

  @override
  Future<app_user.User> getCurrentUser() {
    // TODO: implement getCurrentUser
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

  app_user.User _firebaaseUserToAppUser(firebase.User firebaseUser) {
    return app_user.User(
      name:
          firebaseUser.displayName ??
          firebaseUser.email?.split("@")[0] ??
          'user',
      email: firebaseUser.email ?? "Email user",
    );
  }
}
