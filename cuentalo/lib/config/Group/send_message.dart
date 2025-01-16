import 'package:cuentalo/presentation/screens.dart';

class Messages {
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final prefs = PreferenciasUsuario();

  static sendMessage(BuildContext context, messageController) async {
    try {
      await firestore
          .collection('Cuentalo')
          .doc('Groups')
          .collection(prefs.nombreGrupo)
          .doc(prefs.id.toString())
          .set({
        'Nombre': auth.currentUser!.displayName!,
        'Mensaje': messageController.text,
        'id': prefs.id
      });
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context, e.toString());
      }
    }
  }

  static sendPapel(BuildContext context) async {
    try {
      await firestore
          .collection('Cuentalo')
          .doc('Groups')
          .collection(prefs.nombreGrupo)
          .doc(prefs.id.toString())
          .set({
        'Nombre': auth.currentUser!.displayName!,
        'Mensaje': auth.currentUser!.displayName! + '  sumo un nuevo Vladimir!',
        'id': prefs.id
      });
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context, e.toString());
      }
    }
  }
}
