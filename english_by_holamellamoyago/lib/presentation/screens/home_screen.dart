import 'package:english_by_holamellamoyago/presentation/screens.dart';


class HomeScreen extends StatelessWidget {
  static const routeName = "/";
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const TitleMediumCustom(titulo: "Escoge tu modo de juego", sp: 4),
          PaddingCustom(
            height: size.height * 0.05,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                EnglishAnimatedContainer(
                  texto: "Verbos\nirregulares",
                ),
                EnglishAnimatedContainer(texto: "Verbos\nregulares"),
                EnglishAnimatedContainer(texto: "Frases\nhechas")
              ],
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
  });

  final String texto;

  @override
  State<EnglishAnimatedContainer> createState() => _EnglishAnimatedContainerState();
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
        child: BodyCustom(
          titulo: widget.texto,
          sp: 4,
          align: TextAlign.center,
        ),
      ),
    );
  }
}
