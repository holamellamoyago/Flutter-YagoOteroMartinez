import 'package:cuentalo/presentation/screens.dart';


class TutorialScreen extends StatelessWidget {
  static const routename = '/tutorial';
  const TutorialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedGradient(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [BodyCustom(titulo: 'Aquí inicia')],
          ),
        ),
      ),
    );
  }
}
