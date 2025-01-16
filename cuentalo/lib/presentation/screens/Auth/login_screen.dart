// ignore_for_file: use_build_context_synchronously


import 'package:cuentalo/presentation/screens.dart';


class LoginPage extends StatefulWidget {
  static const name = '/login';
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseauthService _auth = FirebaseauthService();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
              centerTitle: true,
                  title: const TitleLargeCustom(titulo: 'Cuéntalo'),),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
        Image.asset(
          'assets/logo.png',
          height: 40.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              width: 50,
              height: 2,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(100),
                ),
                color: colors.primary,
              ),
            ),
            const Text('Inicia sesión con los siguientes métodos' ),
                            Container(
              width: 50,
              height: 2,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(100),
                ),
                color: colors.primary,
              ),
            ),
          ],
        ),
        PaddingCustom(height: 4.h,),
        GestureDetector(
          onTap: () async {
            try {
              final user = await _auth.signInWithGoogle();
              if (user != null) {
                _signInGoogle();
                context.go('/');
              }
            } on FirebaseAuthException {
              return;
              // showSnackBar(context, e.message?? 'Algo salio mal');
            }
        
          },
          child: Container(
            padding: const EdgeInsets.all(40),
            height: 60,
            width: 60,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(100),
                image: const DecorationImage(
                    image: AssetImage('assets/google.png'))),
          ),
        ),
                  ],
                ),
      ),
    );
  }

  void _sigIn() async {
    var prefs = PreferenciasUsuario();
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    final token = await messaging.getToken();
    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _auth.sigInWithEmailAndPassword(email, password);

    if (user != null) {
      context.push('/');
      prefs.ultimaPagina = '/';
      prefs.ultimouid = user.uid;
      FirebaseFirestore.instance
          .collection('User')
          .doc(user.uid)
          .update({'token': token});
      showSnackBar(context, 'Inicio sesion correctamente');
    } else {
      showSnackBar(context, 'Error de contraseña o mail ');
    }
  }

  void _signInGoogle() async {
    var prefs = PreferenciasUsuario();
    User? user = FirebaseAuth.instance.currentUser;
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    // final token = await messaging.getToken();
    final username = user?.displayName;
    final uid = user?.uid;
    const password = 'No hay contrrasna';
    const subscription = 'Tarifa basica';
    final email = user?.email;

    if (user != null) {
      prefs.ultimouid = user.uid;
      prefs.ultimaPagina = '/';

      FirebaseFirestore.instance.collection('User').doc(uid).set({
        'admin': true,
        'username': username,
        'password': password,
        'subscription': subscription,
        'email': email,
        // 'token': token
      });
      // FirebaseFirestore.instance.collection('User').doc(uid).set({
      //   'admin': true,
      //   'username': username,
      //   'password': password,
      //   'subscription': subscription,
      //   'email': email,
      //   'token': token
      // });

      try {
      await FirebaseFirestore.instance.collection('Cuentalo').doc('Users').collection(email!).doc('Groups').update({'a': 'a'});
        
      } catch (e) {
              await FirebaseFirestore.instance.collection('Cuentalo').doc('Users').collection(email!).doc('Groups').set({'a': 'a'});

      }


    } else {
      showSnackBar(context, 'Error en el login_screen 172');
    }
  }
}
