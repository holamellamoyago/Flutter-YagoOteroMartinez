import 'package:english_by_holamellamoyago/presentation/screens.dart';

class FailScreen extends StatelessWidget {
  static const routename = '/failScreen';
  const FailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final v = Verbo();
    final p = Partida();
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.grey[300],
                boxShadow: const [BoxShadow(offset: Offset(6, 6))],
                border: Border.all()),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TitleLargeCustom(
                        titulo: 'Your score is : ${p.contadorPartida}'),
                  ],
                ),
                BodyCustom(
                  titulo:
                      'The verb ${v.verboInfinitivo} ( ${v.traduccion} ), in past simple: ${v.pasadoSimple} and the participle: ${v.pasadoParticipio}',
                ),
                PaddingCustom(height: 10.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  
                  children: [
                    BotonReintentar(),
                    PaddingCustom(width: 4.w,),
                    AnimatedLoadingBorder(
                      borderWidth: 0.2.w,
                      borderColor: Colors.red,
                      padding: EdgeInsets.all(4),
                      child: BotonGuardarDatos())
                    
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BotonGuardarDatos extends StatelessWidget {
  const BotonGuardarDatos({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        
        color: Colors.blue[200]
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween ,
          children: [
            Icon(Icons.refresh, color: Colors.white,),
            PaddingCustom(width: 1.w,),
            BodyCustom(titulo: 'Guardar tus puntos', color: Colors.white, weight: FontWeight.bold,)
          ],
        ),
      ),
    );
  }
}

class BotonReintentar extends StatelessWidget {
  const BotonReintentar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/VIrregulares'),
      child: Container(
        decoration: BoxDecoration(
          
          border: Border.all(),
          color: Colors.blue[200]
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween ,
            children: [
              Icon(Icons.refresh, color: Colors.white,),
              PaddingCustom(width: 1.w,),
              BodyCustom(titulo: 'Reintentar', color: Colors.white, weight: FontWeight.bold,)
            ],
          ),
        ),
      ),
    );
  }
}
