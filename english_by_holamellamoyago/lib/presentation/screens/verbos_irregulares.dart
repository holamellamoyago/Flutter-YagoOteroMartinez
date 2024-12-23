import 'dart:math';

import 'package:english_by_holamellamoyago/config/constants/Verbo.dart';
import 'package:english_by_holamellamoyago/presentation/screens.dart';
import 'package:flutter/rendering.dart';

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

  Future<bool> _seleccionarRandom() async {
    try {
      final future = Supabase.instance.client.from('Verbo');

      FutureBuilder(
        future: future.select(),
        builder: (context, snapshot) {
          final data = snapshot.data!;

          final verbo = Verbo.fromJson(data[0]);

          Verbo(
            idVerbo: verbo.idVerbo,
            infinitivo: verbo.infinitivo,
            pasadoSimple: verbo.pasadoSimple,
            pasadoParticipio: verbo.pasadoParticipio,
            traduccion: verbo.traduccion,
          );

          print(verbo.traduccion);
          return Placeholder();
        },
      );
    } catch (e) {}

    return false;
  }

  _web() {
    final future = Supabase.instance.client.from('Verbo');
    TextEditingController verboController = TextEditingController();
    int containerHeight = 10;

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
          AnimatedContainerTest(),
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
                  final jugadores = snapshot.data!;
                  return ListView.builder(
                    itemCount: jugadores.length,
                    itemBuilder: (context, index) {
                      int n = Random().nextInt(jugadores.length);

                      final jugador = jugadores[n];

                      return Column(
                        children: [
                          AnimatedContainerVerb(
                              jugador: jugador,
                              verboController: verboController),
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
  const AnimatedContainerVerb({
    super.key,
    required this.jugador,
    required this.verboController,
  });

  final PostgrestMap jugador;
  final TextEditingController verboController;

  @override
  State<AnimatedContainerVerb> createState() => _AnimatedContainerVerbState();
}

class _AnimatedContainerVerbState extends State<AnimatedContainerVerb> {
    int containerHeight = 10;
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
      child: Center(
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 0.1.w, vertical: 0.1.h),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BodyCustom(
                    titulo: widget.jugador['infinitivo'] + ': ',
                    weight: FontWeight.bold,
                  ),
                  SizedBox(
                      width: 20.w,
                      child: TextField(controller: widget.verboController)),
                  IconButton.filled(onPressed: () {
                    setState(() {
                      containerHeight = 20;
                    });
                  }, icon: const Icon(Icons.send))
                ],
              ),
            )),
      ),
    );
  }
}

class AnimatedContainerTest extends StatefulWidget {
  const AnimatedContainerTest({
    super.key,
  });

  @override
  State<AnimatedContainerTest> createState() => _AnimatedContainerTestState();
}

class _AnimatedContainerTestState extends State<AnimatedContainerTest> {
  int widthContainer = 10;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          setState(() {
            widthContainer += 10;
            print(widthContainer);
          });
        },
        child: AnimatedContainer(
          duration: Durations.long1,
          width: widthContainer.w,
          color: Colors.blue,
          height: 1.h,
        ));
  }
}
