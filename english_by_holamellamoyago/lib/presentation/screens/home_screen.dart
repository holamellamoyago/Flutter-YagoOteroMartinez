import 'package:english_by_holamellamoyago/config/Auth/Auth.dart';
import 'package:english_by_holamellamoyago/presentation/screens.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = "/";
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final future = Supabase.instance.client.from('Jugador');

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
                  navegacion: 'VIrregulares',
                ),
                EnglishAnimatedContainer(
                  texto: "Verbos\nregulares",
                  navegacion: 'VRegulares',
                ),
                EnglishAnimatedContainer(
                  texto: "Frases\nhechas",
                  navegacion: 'FrasesHechas',
                )
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: future.select(),
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
}

class EnglishAnimatedContainer extends StatefulWidget {
  const EnglishAnimatedContainer({
    super.key,
    required this.texto,
    required this.navegacion,
  });

  final String texto;
  final String navegacion;

  @override
  State<EnglishAnimatedContainer> createState() =>
      _EnglishAnimatedContainerState();
}

class _EnglishAnimatedContainerState extends State<EnglishAnimatedContainer> {
  final FirebaseauthService auth = FirebaseauthService();
  bool selected = false;

  void seleccionado() {
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        seleccionado();
      },
      child: LayoutBuilder(
        builder: (context, constraints) => GestureDetector(
          onTap: () => context.push('/${widget.navegacion}'),
          child: HoverAnimatedContainer(
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
                widget.texto,
                style: TextStyle(
                    fontSize:
                        calcularTamanhoLetra(TipoFuente.body, constraints)),
              )),
        ),
      ),
    );
  }
}
