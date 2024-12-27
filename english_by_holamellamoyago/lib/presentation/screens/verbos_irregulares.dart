import 'dart:math';

import 'package:english_by_holamellamoyago/config/functions/comprobarAcierto.dart';
import 'package:english_by_holamellamoyago/presentation/screens.dart';

class VerbosIrregules extends StatefulWidget {
  static const routename = '/VIrregulares';
  const VerbosIrregules({super.key});

  @override
  State<VerbosIrregules> createState() => _VerbosIrregulesState();
}

class _VerbosIrregulesState extends State<VerbosIrregules> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ResponsiveWidget(
      mobile: Placeholder(),
      tablet: Placeholder(),
      web: _web(),
    ));
  }

  int widthContainer = 1;
  int contadorRecompensa = 0;
  int containerHeight = 10;
  TextEditingController verboController = TextEditingController();
  CarouselSliderController carouselController = CarouselSliderController();
  Respuesta estadoRespuesta = Respuesta.sinContestar;
  final v = Verbo();
  final p = Partida();
  final future = Supabase.instance.client.from('Verbo');

  _web() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey[300],
            boxShadow: [BoxShadow(offset: Offset(6, 6))],
            border: Border.all()),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PaddingCustom(
                height: 4.h,
              ),
              // TODO Arreglar el contador
              BodyCustom(
                titulo: "Points ${contadorRecompensa} of 10 ",
                weight: FontWeight.bold,
              ),
              AnimatedContainer(
                duration: Durations.long1,
                width: widthContainer.w,
                color: Colors.blue,
                height: 1.h,
              ),
              PaddingCustom(
                height: 8.h,
              ),
              TitleLargeCustom(titulo: "Write the past simple of the verb"),
              PaddingCustom(
                height: 0.2.h,
              ),

              Expanded(child: _verbo())
            ],
          ),
        ),
      ),
    );
  }

  _verbo() {
    return FutureBuilder(
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
                carouselController: carouselController,
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
                                          autofocus: true,
                                          onSubmitted: (value) => setState(() {
                                                comprobarAcierto(context, verbo);
                                              }),
                                          controller: verboController)),
                                  IconButton.filled(
                                      style: const ButtonStyle(
                                          backgroundColor:
                                              WidgetStatePropertyAll(
                                                  Colors.black)),
                                      onPressed: () {
                                        comprobarAcierto(context, verbo);
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
                                              titulo: "Congratulations you "),
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
                                          child: Column(
                                            children: [
                                              Row(
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
                                              Row(
                                                children: [
                                                  BodyCustom(
                                                    titulo:
                                                        'The correct form of the verb is ${verbo['pasadoSimple']}',
                                                  ),
                                                ],
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
    );
  }

  comprobarAcierto(BuildContext context, verbo) async {
    if (verboController.text == verbo['pasadoSimple']) {
      setState(() {
        estadoRespuesta = Respuesta.acertado;
        widthContainer += 6;
        contadorRecompensa++;
        containerHeight = 20;
        carouselController.nextPage(
            duration: const Duration(seconds: 1, milliseconds: 500),
            curve: const ElasticInCurve());
        verboController.text = '';
      });

      Future.delayed(const Duration(seconds: 2)).then(
        (value) {
          setState(() {
            containerHeight = 10;
            estadoRespuesta = Respuesta.sinContestar;
          });
        },
      );
    } else {
      v.verboInfinitivo = verbo['infinitivo'];
      v.pasadoSimple = verbo['pasadoSimple'];
      v.pasadoParticipio = verbo['pasadoParticipio'];
      v.traduccion = verbo['traduccion'];

      p.contadorPartida = contadorRecompensa;

      context.push('/failScreen');
    }
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
              : estadoRespuesta == Respuesta.fallido
                  ? SizedBox(
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
                    )
                  : SizedBox()
        ],
      ),
    );
  }
}

// class AnimatedContainerTest extends StatefulWidget {
//   AnimatedContainerTest({
//     super.key,
//     required this.widthContainer,
//   });

//   int widthContainer;

//   @override
//   State<AnimatedContainerTest> createState() => _AnimatedContainerTestState();
// }

// class _AnimatedContainerTestState extends State<AnimatedContainerTest> {
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//         onTap: () {
//           setState(() {
//             widthContainer += 10;
//           });
//         },
//         child: AnimatedContainer(
//           duration: Durations.long1,
//           width: widthContainer.w,
//           color: Colors.blue,
//           height: 1.h,
//         ));
//   }
// }
