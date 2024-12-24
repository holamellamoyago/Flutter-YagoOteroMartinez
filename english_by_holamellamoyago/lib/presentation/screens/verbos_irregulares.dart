import 'dart:math';

import 'package:english_by_holamellamoyago/config/constants/verbo.dart';
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
    ));
  }

  _web() {
    final future = Supabase.instance.client.from('Verbo');
    TextEditingController verboController = TextEditingController();
    int widthContainer = 10;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PaddingCustom(
            height: 1.h,
          ),
          // TODO Arreglar el contador
          BodyCustom(
            titulo: "Level 1 of XX, 1 de 99 ",
            weight: FontWeight.bold,
          ),
          AnimatedContainerTest(
            widthContainer: widthContainer,
          ),
          TitleLargeCustom(titulo: "Write the past simple of the verb"),
          PaddingCustom(
            height: 0.2.h,
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
                  final verbos = snapshot.data!;
                  return ListView.builder(
                    itemCount: verbos.length,
                    itemBuilder: (context, index) {
                      int n = Random().nextInt(verbos.length);

                      final verbo = verbos[n];

                      return Column(
                        children: [
                          AnimatedContainerVerb(
                            jugador: verbo,
                            verboController: verboController,
                            widthtContainer: widthContainer,
                          ),
                        ],
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

class AnimatedContainerVerb extends StatefulWidget {
  AnimatedContainerVerb(
      {super.key,
      required this.jugador,
      required this.verboController,
      required this.widthtContainer});

  final PostgrestMap jugador;
  final TextEditingController verboController;
  int widthtContainer;

  @override
  State<AnimatedContainerVerb> createState() => _AnimatedContainerVerbState();
}

class _AnimatedContainerVerbState extends State<AnimatedContainerVerb> {
  int containerHeight = 10;

  Respuesta estadoRespuesta = Respuesta.sinContestar;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: containerHeight.h,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(10),
        color: Colors.blue[200],
      ),
      duration: Durations.medium1,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BodyCustom(
                titulo: widget.jugador['infinitivo'] + ': ',
                weight: FontWeight.bold,
              ),
              SizedBox(
                  width: 20.w,
                  child: TextField(controller: widget.verboController)),
              IconButton.filled(
                  onPressed: () {
                    if (widget.verboController.text ==
                        widget.jugador['pasadoSimple']) {
                      estadoRespuesta = Respuesta.acertado;

                      setState(() {
                        widget.widthtContainer = 40;
                      });
                    } else {
                      estadoRespuesta = Respuesta.fallido;
                    }

                    setState(() {
                      containerHeight = 20;
                    });
                  },
                  icon: const Icon(Icons.send))
            ],
          ),
          estadoRespuesta == Respuesta.acertado
              ? SizedBox(
                  height: 10.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const BodyCustom(titulo: "Congratulations you "),
                      BodyCustom(
                          titulo: "won! ",
                          weight: FontWeight.bold,
                          color: Colors.green[600])
                    ],
                  ),
                )
              : estadoRespuesta == Respuesta.fallido? SizedBox(
                  height: 10.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const BodyCustom(titulo: "Oh sorry ... "),
                      BodyCustom(
                        titulo: "you fail",
                        weight: FontWeight.bold,
                        color: Colors.red[600],
                      )
                    ],
                  ),
                ) : SizedBox()
        ],
      ),
    );
  }
}

class AnimatedContainerTest extends StatefulWidget {
  AnimatedContainerTest({
    super.key,
    required this.widthContainer,
  });

  int widthContainer;

  @override
  State<AnimatedContainerTest> createState() => _AnimatedContainerTestState();
}

class _AnimatedContainerTestState extends State<AnimatedContainerTest> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          setState(() {
            widget.widthContainer += 10;
          });
        },
        child: AnimatedContainer(
          duration: Durations.long1,
          width: widget.widthContainer.w,
          color: Colors.blue,
          height: 1.h,
        ));
  }
}
