import 'dart:math';

import 'package:english_by_holamellamoyago/presentation/screens.dart';

class VerbosRegulares extends StatefulWidget {
  static const routename = '/VRegulares';
  const VerbosRegulares({super.key});

  @override
  State<VerbosRegulares> createState() => _VerbosRegularesState();
}

class _VerbosRegularesState extends State<VerbosRegulares> {
  int widthContainer = 1;
  int contadorRecompensa = 0;
  int containerHeight = 10;
  TextEditingController verboController = TextEditingController();
  CarouselSliderController carouselController = CarouselSliderController();
  Respuesta estadoRespuesta = Respuesta.sinContestar;
  final future = Supabase.instance.client.from('Verbo');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Expanded(
        child: FutureBuilder(
          future: future.select(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              final verbos = snapshot.data!;
              return SizedBox(
                width: double.infinity,
                height: containerHeight.h,
                child: CarouselSlider.builder(
                    disableGesture: false,
                    itemCount: verbos.length,
                    itemBuilder: (context, index, realIndex) {
                      int n = Random().nextInt(verbos.length);

                      final verbo = verbos[n];

                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AnimatedContainer(
                              height: containerHeight.h,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.blue[200],
                              ),
                              duration: Durations.medium1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      BodyCustom(
                                        titulo: verbo['infinitivo'] + ': ',
                                        weight: FontWeight.bold,
                                      ),
                                      SizedBox(
                                          width: 20.w,
                                          child: TextField(
                                              controller: verboController)),
                                      IconButton.filled(
                                          style: const ButtonStyle(
                                              backgroundColor:
                                                  WidgetStatePropertyAll(
                                                      Colors.black)),
                                          onPressed: () {
                                            if (verboController.text ==
                                                verbo['pasadoSimple']) {
                                              setState(() {
                                                estadoRespuesta =
                                                    Respuesta.acertado;
                                                widthContainer += 6;
                                                contadorRecompensa++;
                                                containerHeight = 20;
                                                carouselController.nextPage(
                                                    duration:
                                                        Durations.extralong1,
                                                    curve: ElasticInCurve());
                                              });
                                            } else {
                                              setState(() {
                                                containerHeight = 20;
                                                estadoRespuesta =
                                                    Respuesta.fallido;
                                              });
                                            }
                                          },
                                          icon: const Icon(Icons.send))
                                    ],
                                  ),
                                  estadoRespuesta == Respuesta.acertado
                                      ? SizedBox(
                                          height: 10.h,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const BodyCustom(
                                                  titulo:
                                                      "Congratulations you "),
                                              BodyCustom(
                                                  titulo: "won! ",
                                                  weight: FontWeight.bold,
                                                  color: Colors.green[600])
                                            ],
                                          ),
                                        )
                                      : estadoRespuesta == Respuesta.fallido
                                          ? SizedBox(
                                              height: 10.h,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const BodyCustom(
                                                      titulo: "Oh sorry ... "),
                                                  BodyCustom(
                                                    titulo: "you fail",
                                                    weight: FontWeight.bold,
                                                    color: Colors.red[600],
                                                  )
                                                ],
                                              ),
                                            )
                                          : SizedBox()
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    options: CarouselOptions(
                      autoPlay: false,
                    )),
              );
            }
          },
        ),
      ),
    );
  }
}
