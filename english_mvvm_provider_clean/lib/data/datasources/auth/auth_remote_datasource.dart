import 'package:english_mvvm_provider_clean/data/datasources/auth/auth_datasource.dart';
import 'package:english_mvvm_provider_clean/domain/entities/user.dart'
    as app_user;
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:google_sign_in/google_sign_in.dart';

class AuthRemoteDatasource implements AuthDatasource {
  final firebase.FirebaseAuth _auth = firebase.FirebaseAuth.instance;
  late firebase.User firebaseUser;

  @override
  Future<app_user.User> loginWithEmail() {
    throw UnimplementedError();
  }

  @override
  bool isLoggedIn() {
    bool isLoggin = false;
    _auth.authStateChanges().listen((firebase.User? user) {
      if (user != null) {
        isLoggin = true;
      }
    });

    return isLoggin;
  }

  @override
  Future<app_user.User> loginWithGoogle() async {
    final GoogleSignInAccount googleUser = await GoogleSignIn.instance.authenticate();

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    // final credential = firebase.GoogleAuthProvider.credential(accessToken: googleAuth?.)
    
    return app_user.User(name: googleUser.displayName!, email: googleUser.email);

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
}
