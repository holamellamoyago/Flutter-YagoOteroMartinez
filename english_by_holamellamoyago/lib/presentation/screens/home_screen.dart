import 'package:english_by_holamellamoyago/config/Sizer/sizer.dart';
import 'package:english_by_holamellamoyago/presentation/screens.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = "/";
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _future = Supabase.instance.client.from('Jugador');

    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleLargeCustom(titulo: "Titulo"),
              TitleMediumCustom(titulo: "Titulo"),
              TitleSmallcustom(titulo: "Titulo"),
              BodyCustom(titulo: "Titulo")
            ],
          ),
          PaddingCustom(
            height: size.height * 0.05,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.25),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                EnglishAnimatedContainer(
                  texto: "Verbos\nirregulares",
                ),
                EnglishAnimatedContainer(texto: "Verbos\nregulares"),
                EnglishAnimatedContainer(texto: "Frases\nhechas")
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _future.select(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  final jugadores = snapshot.data!;
                  return ListView.builder(
                    itemCount: jugadores.length,
                    itemBuilder: (context, index) {
                      final jugador = jugadores[index];
                      return ListTile(
                        title: BodyCustom(titulo: jugador['nickname']),
                      );
                    },
                  );
                }
              },
            ),
          ) 
        ],
      ),
    );
  }

  crearUsuario(){
    try {
      
    } catch (e) {
      print(e);
    }
  }
}

class EnglishAnimatedContainer extends StatefulWidget {
  const EnglishAnimatedContainer({
    super.key,
    required this.texto,
  });

  final String texto;

  @override
  State<EnglishAnimatedContainer> createState() =>
      _EnglishAnimatedContainerState();
}

class _EnglishAnimatedContainerState extends State<EnglishAnimatedContainer> {
  bool selected = false;

  void seleccionado() {
    setState(() {
      selected = !selected;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        seleccionado();
      },
      child: LayoutBuilder(
        builder: (context, constraints) => HoverAnimatedContainer(
            width: size.width * 0.1,
            height: size.height * 0.12,
            padding: EdgeInsets.all(size.width * 0.01),
            hoverDecoration: BoxDecoration(
                color: selected ? Colors.red[400] : Colors.grey[400],
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey[600]!,
                      offset: const Offset(8, 8),
                      blurRadius: 5),
                ]),
            decoration: BoxDecoration(
              color: selected ? Colors.red[400] : Colors.grey[400],
              border: Border.all(),
            ),
            child: Text(
              "Hola",
              style: TextStyle(
                  fontSize: calcularTamanhoLetra(TipoFuente.body, constraints)),
            )),
      ),
    );
  }
}
