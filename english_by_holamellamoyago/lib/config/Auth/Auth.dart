import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseauthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> loginGoogle() async {
    final accountGoogle = await GoogleSignIn().signIn();
    final googleAuth = await accountGoogle?.authentication;
    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);

    final userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

        print('logueado');  

    return userCredential.user;
  }

  Future comprobarEstado() async {
    FirebaseAuth.instance.userChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
  }
}
