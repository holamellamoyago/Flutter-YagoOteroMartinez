import 'package:english_mvvm_provider_clean/data/datasources/auth/auth_datasource.dart';
import 'package:english_mvvm_provider_clean/domain/entities/app_user.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthDatasource implements AuthDatasource {
  final firebase.FirebaseAuth _auth = firebase.FirebaseAuth.instance;

  // Hecho
  @override
  bool isLoggedIn() {
    return _auth.currentUser != null;
  }

  @override
  Future<AppUser> createAccountEmailPassword(
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
  Future<AppUser> loginWithEmail(String email, String password) async {
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

  @override
  Future<void> logout() async {
    await _auth.signOut();
  }

  @override
  Future<AppUser> loginWithGoogle() async {
    GoogleSignIn googleSignIn = GoogleSignIn(
      // signInOption: SignInOption.games,
      // clientId: "122440637695-msibjrkbd54uq3ib6ro00t91sv9k6ql3.apps.googleusercontent.com",
    );

    try {
      final GoogleSignInAccount? account = await googleSignIn.signIn();
      if (account == null) throw Exception('Sign in cancelled');

      final GoogleSignInAuthentication auth = await account.authentication;

      // Crea credenciales para Firebase
      final firebase.AuthCredential credential =
          firebase.GoogleAuthProvider.credential(
            accessToken: auth.accessToken,
            idToken: auth.idToken,
          );

      // Autentica con Firebase
      final firebase.UserCredential userCredential = await _auth
          .signInWithCredential(credential);

      return _firebaaseUserToAppUser(userCredential.user!);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<AppUser> loginAnonimously() async {
    firebase.UserCredential user = await _auth.signInAnonymously();

    return _firebaaseUserToAppUser(user.user!);
  }

  @override
  Future<AppUser> getCurrentUser() async {
    return _firebaaseUserToAppUser(_auth.currentUser!);
  }

  AppUser _firebaaseUserToAppUser(firebase.User firebaseUser) {
    return AppUser(
      image: firebaseUser.photoURL,
      name:
          firebaseUser.displayName ??
          firebaseUser.email?.split("@")[0] ??
          'user',
      username:
          firebaseUser.displayName ??
          firebaseUser.email?.split("@")[0] ??
          'user',
      email: firebaseUser.email ?? "Email user",
    );
  }
}
