import 'package:english_by_holamellamoyago/presentation/screens.dart';

class RegisterScreen extends StatelessWidget {
  static const routename = '/register';
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController password2Controller = TextEditingController();
    // final FirebaseauthService auth = FirebaseauthService();
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 19.w, vertical: 15.h),
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
                  TitleLargeCustom(titulo: 'Create new account'),
                  BodyCustom(
                    titulo:
                        'Sign up in our website to save all your\nscores and points to fight with others',
                    align: TextAlign.center,
                  ),
                  TextFieldCustom(
                    controller: emailController,
                    label: 'Email',
                  ),
                  PaddingCustom(
                    height: 1.h,
                  ),
                  TextFieldCustom(
                      controller: passwordController, label: 'password'),
                  PaddingCustom(
                    height: 1.h,
                  ),
                  TextFieldCustom(
                      controller: password2Controller,
                      label: 'confirm password'),
                  PaddingCustom(
                    height: 2.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FilledButton(
                        onPressed: () async {
                          await SupabaseAuth().createAccountEmailPassword(context, emailController, passwordController, password2Controller)
                              ? context.go('/')
                              : showSnackBar(context, 'Eror');
                        },
                        child: const BodyCustom(
                            titulo: 'Create new account'), // Registrarse
                      ),
                      PaddingCustom( 
                        width: 1.w,
                      ),
                      const BodyCustom(titulo: ' or '),
                      PaddingCustom(
                        width: 1.w,
                      ),
                      FilledButton(
                        onPressed: () {
                          context.go('/login');
                        },
                        child: const BodyCustom(titulo: 'Login'),
                      ),
                      PaddingCustom(
                        height: 1.h,
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
                      const BodyCustom(titulo: ' or '),
                      Container(
                        height: 1,
                        width: 20.w,
                        color: Colors.black,
                      ),
                    ],
                  ),
                  // TODO Hacer el inicio de sesión con google
                  GestureDetector(
                    onTap: () {},
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
