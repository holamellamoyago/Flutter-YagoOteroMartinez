import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

class FirebaseauthService {
  // final FirebaseAuth _auth = FirebaseAuth.instance;

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

class SupabaseAuth {
  Future<bool> createAccountEmailPassword() async {
    try {
      final future = supabase.Supabase.instance.client.from('Jugador');
      final user = await FirebaseauthService().loginGoogle();

      final FirebaseAuth _auth = FirebaseAuth.instance;
      if (user != null) {
        print(_auth.currentUser?.displayName);
        try {
          await future.insert(
              {'nickname': '${user.displayName}', 'contrasena': '${user.uid}'});
          return true;
        } catch (e) {
          print(e);
          return false;
        }
      } else {
        return false;
      }
    } on Exception catch (e) {
      print(e);
      print('Fallo al iniciar sesion con googole');
      return false;
    }
  }
}
