import 'package:english_by_holamellamoyago/presentation/screens.dart';

class VerbosIrregules extends StatelessWidget {
  static const routename = '/VIrregulares';
  const VerbosIrregules({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveWidget(
        mobile: Placeholder(),
        tablet: Placeholder(),
        web: _web(),
      )
    );
  }

  Future<bool> _seleccionarRandom() async {

    try {
      final future = Supabase.instance.client;
      future.from('Verbo');
    } catch (e) {
      
    }

    return false;
  }

  _web(){
    return Center(
      child: Column(
        children: [
          TitleLargeCustom(titulo: "Deberás seleccionar el verbo correcto"),
          BodyCustom(titulo: "Selecciona el verbo correctoe en estas 3 opciones"),
          PaddingCustom(height: 0.2.h,)
          TitleMediumCustom(titulo: "¿Cual es el ")

        ],
      ),
    );
  }
}