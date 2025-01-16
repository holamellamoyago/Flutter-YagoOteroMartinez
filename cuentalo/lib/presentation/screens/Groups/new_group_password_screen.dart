import 'package:cuentalo/presentation/screens.dart';
class CreateGroupPasswordScreen extends StatelessWidget {
  static const routename = '/createGroupPassword';
  const CreateGroupPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const TitleLargeCustom(titulo: 'Cuéntalo'),
        ),
        body: const PanelPassword(isCreating: true,));
  }
}