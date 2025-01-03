import 'package:english_by_holamellamoyago/config/constants/Jugador.dart';
import 'package:english_by_holamellamoyago/presentation/screens.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as s;
import 'package:firebase_auth/firebase_auth.dart' as f;

class FirebaseauthService {
  // final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> loginGoogle(BuildContext context) async {
    try {
      final accountGoogle = await GoogleSignIn().signIn();
      final googleAuth = await accountGoogle?.authentication;
      final credential = f.GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);

      final userCredential =
          await f.FirebaseAuth.instance.signInWithCredential(credential);

      print('logueado');

      return true;
    } catch (e) {
      showSnackBar(context, e.toString());
      return false;
    }
  }

  Future<bool> createAccountEmailPassword(
      BuildContext context,
      TextEditingController emailController,
      TextEditingController passwordController) async {
    try {
      final credential =
          await f.FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      final user = f.FirebaseAuth.instance.currentUser?.email;
      showSnackBar(context, user!);

      // await setJugador(credential.user!.displayName, credential.user!.email, credential.user!.uid);
      
      print(Jugador().email);
      return true;
    } on f.FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showSnackBar(context, 'The password provided is too weak.');
        return false;
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        showSnackBar(context, 'The account already exists for that email.');
      }
      return false;
    } catch (e) {
      showSnackBar(context, e.toString());
      return false;
    }
  }
}

class SupabaseAuth {
  final SupabaseClient supabase = Supabase.instance.client;
  late final jugador = supabase.from('Jugador');

  Future<bool> sigInInEmailPassword(
      BuildContext context, emailController, passwordController) async {
    try {
      await supabase.auth.signInWithPassword(
          password: passwordController.text, email: emailController.text);
      final user = supabase.auth.currentUser;
      showSnackBar(context, user!.id);
      return true;
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context, e.toString());
        return false;
      }
    }

    return false;
  }

  Future<bool> createAccountEmailPassword(BuildContext context, emailController,
      passwordController, password2Controller) async {
    final SupabaseClient supabase = Supabase.instance.client;

    // Aquºi compruebo que las contraseças coincidan
    if (passwordController.text == password2Controller.text) {
      // Ejecuto la funciºon para que registre la sesion en flutter
      try {
        final user = await supabase.auth.signUp(
            password: passwordController.text, email: emailController.text);
        print('Registro hecho');
        await sigInInEmailPassword(
            context, emailController, passwordController);

        print('Inicio');

        if (context.mounted) {
          showSnackBar(context, 'Creado');
        }
        // Ejecuto que se inserte en la tabla User de la bd
        if (user != null) {
          return await registrarJugador(context);
        } else {
          showSnackBar(context, 'Error en registrarlo en la tabla');
          return false;
        }
      } catch (e) {
        if (context.mounted) {
          showSnackBar(context, e.toString());
        }

        return false;
      }
    } else {
      // TODO Hacer que se ponga en rojo
      return false;
    }
  }

  Future<bool> registrarJugador(BuildContext context) async {
    final user = supabase.auth.currentUser;
    try {
      await jugador.insert({
        'UID': user!.id,
      });
      return true;
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context, e.toString());
      }
      return false;
    }
  }

  Future<bool> realizarPrueba(BuildContext context) async {
    try {
      final userIniciado = await supabase.auth.signInWithPassword(
          email: 'yagootero2003@gmail.com', password: 'abc123.');
      final user2 = await supabase.auth.currentUser;
      showSnackBar(context, user2!.id);
      return true;
    } catch (e) {
      showSnackBar(context, e.toString());
      return false;
    }
  }
}


setJugador(nickname, email, uid){
  final j = Jugador();

  j.nickname = nickname;
  j.email = email;
  j.uid = uid;
  j.logueado = true;
}