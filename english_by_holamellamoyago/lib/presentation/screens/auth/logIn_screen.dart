import 'package:cached_network_image/cached_network_image.dart';
import 'package:english_by_holamellamoyago/config/Auth/Auth.dart';
import 'package:english_by_holamellamoyago/config/constants/Colors.dart';
import 'package:english_by_holamellamoyago/presentation/screens.dart';
import 'package:firebase_auth/firebase_auth.dart';
export 'package:supabase_flutter/supabase_flutter.dart';

class LogInScreen extends StatelessWidget {
  static const routename = '/logIn';
  const LogInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController password2Controller = TextEditingController();
    final SupabaseClient supabase = Supabase.instance.client;
    final FirebaseauthService auth = FirebaseauthService();
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 19.w, vertical: 16.h),
          child: Container(
            decoration: BoxDecoration(
                color: ColorsCustom.primario,
                border: Border.all(),
                borderRadius: BorderRadius.circular(8)),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TitleLargeCustom(titulo: 'Log in'),
                  BodyCustom(
                    titulo:
                        'Log in our website to save all your\nscores and points to fight with others',
                    align: TextAlign.center,
                  ),
                  TextFieldCustom(
                      label: 'Introduce tu mail', controller: emailController),
                  TextFieldCustom(
                      label: 'Introduce la contraseña',
                      controller: passwordController),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FilledButton(
                        onPressed: () async {},
                        child: BodyCustom(
                            titulo:
                                'You don´t have account? Sign up'), // Registrarse
                      ),
                      FilledButton(
                        onPressed: () async {
                          try {
                            await supabase.auth.signInWithPassword(
                                
                                password: passwordController.text,
                                email: emailController.text);
                            if (context.mounted) {
                              showSnackBar(context, 'Sesión iniciada');
                            }
                            context.go('/');
                          } catch (e) {
                            print(e);
                            if (context.mounted) {
                              showSnackBar(context, 'Error');
                            }
                          }
                        },
                        child: BodyCustom(titulo: 'Login in'),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 1,
                        width: 20.w,
                        color: Colors.black,
                      ),
                      BodyCustom(titulo: ' or '),
                      Container(
                        height: 1,
                        width: 20.w,
                        color: Colors.black,
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () async {
                      try {
                        final future = Supabase.instance.client.from('Jugador');
                        final user = await FirebaseauthService().loginGoogle();

                        final FirebaseAuth _auth = FirebaseAuth.instance;
                        if (user != null) {
                          print(_auth.currentUser?.displayName);
                          try {
                            await future.insert({
                              'nickname': '${user.displayName}',
                              'contrasena': '${user.uid}'
                            });
                          } catch (e) {
                            print(e);
                          }
                        }
                      } on Exception catch (e) {
                        print(e);
                        print('Fallo al iniciar sesion con googole');
                      }
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(8)),
                        height: 10.h,
                        child: CachedNetworkImage(
                            imageUrl:
                                'https://firebasestorage.googleapis.com/v0/b/hiitgym-2ae99.appspot.com/o/Holamellamoyago%2Fgoogle.png?alt=media&token=5acae772-e7e1-4581-8075-4aa86371406a')),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
