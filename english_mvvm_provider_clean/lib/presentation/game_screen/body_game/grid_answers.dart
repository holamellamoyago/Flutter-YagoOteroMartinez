import 'package:english_mvvm_provider_clean/data/viewmodel/words_viewmodel.dart';
import 'package:english_mvvm_provider_clean/presentation/game_screen/body_game/answer_button.dart';
import 'package:english_mvvm_provider_clean/data/viewmodel/carousel_viewmodel.dart';
import 'package:english_mvvm_provider_clean/data/viewmodel/clock_viewmodel.dart';
import 'package:english_mvvm_provider_clean/utils/snackbar_utils.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:english_mvvm_provider_clean/data/strings/app_strings.dart';
import 'package:english_mvvm_provider_clean/domain/entities/word.dart';
import 'package:provider/provider.dart';

class GridTestWidget extends StatelessWidget {
  final List<Word> words;
  final int index;
  final CarouselViewmodel carouselProvider;
  final WordsViewModel wordsProvider;

  const GridTestWidget({
    super.key,
    required this.words,
    required this.index,
    required this.carouselProvider,
    required this.wordsProvider,
  });

  @override
  Widget build(BuildContext context) {
    var word = words.elementAt(index);
    var random = Random();
    var strings = AppStrings();

    ClockViewmodel clockProvider = Provider.of<ClockViewmodel>(
      context,
      listen: false,
    );

    var answers = _generateUniqueRandomNumber();
    answers[random.nextInt(answers.length - 1)] = word.spanish;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Text(
            strings.question_1 + word.english + strings.question_2,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          SizedBox(height: 16),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                AnswerButton(
                  text: answers[0],
                  color: Colors.red,
                  onTap: () => _checkAnswer(context, clockProvider, answers[0]),
                ),
                SizedBox(width: 16),
                AnswerButton(
                  text: answers[1],
                  color: Colors.blue,
                  onTap: () => _checkAnswer(context, clockProvider, answers[1]),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                AnswerButton(
                  text: answers[2],
                  color: Colors.orange,
                  onTap: () => _checkAnswer(context, clockProvider, answers[2]),
                ),
                SizedBox(width: 16),
                AnswerButton(
                  text: answers[3],
                  color: Colors.green,
                  onTap: () => _checkAnswer(context, clockProvider, answers[3]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<String> _generateUniqueRandomNumber() {
    var rdm = Random();
    List<int> numerosSeleccionados = [index];
    List<String> l = [];

    for (var i = 0; i < 4; i++) {
      var numRandom = rdm.nextInt(words.length);

      while (numerosSeleccionados.contains(numRandom)) {
        numRandom = rdm.nextInt(words.length);
      }

      numerosSeleccionados.add(numRandom);
      l.add(words[numRandom].spanish);
    }

    return l;
  }

  /* 
    TODO
    1.
    En esta función tengo que comprobar que termine el juego , si esta en la última pestaña cambiar a 
    otra pantalla donde muestre los resultados 

    2. 
    Quiero implementar un sistema de puntuaciones mejor , restar si falla, corazones , notificaciones si 
    suma o resta puntos , que sume mas o menos en función del tiempo que tarde en responder.

    3. 
    Mirar el tema de los niveles, los testers se me quejaron de que 10 seg se le hacian pequeños 
    entonces intentar hacer un calculo de:
    cogemos total de segundos: 10 
       devolver un map<NivelDificultad, Map<String, double>>
       
       que en base al nivel de dificultad que tgengas te devuelva el map que tenga 
        puntos -> acertado 1.2 y después se hace 
  */

  void _checkAnswer(
    BuildContext context,
    ClockViewmodel clockProvider,
    String text,
  ) {
    if (text == words.elementAt(index).spanish) {
      carouselProvider.addPoints();
      clockProvider.countDownController.restart();

      // Actualización 19/12 - Hacer que se pare cuando lleva el total de preguntas.
      if ((index + 1) >= wordsProvider.words!.length) {
        clockProvider.countDownController.pause();
        clockProvider.openDialog(context, true);
      }
      
    } else {
      carouselProvider.subtractPoints();
      showSnackBar(context, AppStrings.incorrectAnswer);
    }
  }
}
