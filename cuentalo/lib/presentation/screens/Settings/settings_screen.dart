import 'package:cuentalo/presentation/screens.dart';

class SettingsScreen extends StatelessWidget {
  static const routename = '/settings';
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BodyCustom(titulo: 'Ajustes'),
      ),
    );
  }
}