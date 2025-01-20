import '../../presentation/screens.dart';

class FirestoreService {
  Future<List<String>> getCategories(BuildContext context) async {
    var prefs = PreferenciasUsuario();

    try {
      // Obtiene la referencia de la colección.
      final collectionRef = FirebaseFirestore.instance
          .collection('Cuentalo')
          .doc('Groups')
          .collection(prefs.nombreGrupo)
          .doc('Info')
          .collection('colecciones');

      // Obtiene los documentos de la colección.
      final querySnapshot = await collectionRef.get();

      // Mapea los IDs de los documentos.
      return querySnapshot.docs.map((doc) => doc.id).toList();
    } catch (e) {
      if (context.mounted) {
        showSnackBar(context, 'Error $e');
      }
      return [];
    }
  }
}
