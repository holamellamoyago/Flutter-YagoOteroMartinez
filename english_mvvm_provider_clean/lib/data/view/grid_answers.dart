import 'package:english_mvvm_provider_clean/data/view/answer_button.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:english_mvvm_provider_clean/data/strings/app_strings.dart';
import 'package:english_mvvm_provider_clean/domain/entities/word.dart';

class GridTestWidget extends StatelessWidget {
  final List<Word> words;
  final int index;
  final CarouselSliderController carouselProvider;

  const GridTestWidget({
    super.key,
    required this.words,
    required this.index,
    required this.carouselProvider,
  });

  @override
  Widget build(BuildContext context) {
    var word = words.elementAt(index);
    var random = Random();
    var strings = AppStrings();

    var answers = _generateUniqueRandomNumber();
    answers[random.nextInt(answers.length - 1)] = word.spanish;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Text(
            strings.question_1 + word.english + strings.question_2,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          SizedBox(height: 16),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                AnswerButton(
                  text: answers[0],
                  color: Colors.red,
                  onTap: () => _checkAnswer(carouselProvider, answers[0]),
                ),
                SizedBox(width: 16),
                AnswerButton(
                  text: answers[1],
                  color: Colors.blue,
                  onTap: () => _checkAnswer(carouselProvider, answers[1]),
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
                  onTap: () => _checkAnswer(carouselProvider, answers[2]),
                ),
                SizedBox(width: 16),
                AnswerButton(
                  text: answers[3],
                  color: Colors.green,
                  onTap: () => _checkAnswer(carouselProvider, answers[3]),
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

  void _checkAnswer(CarouselSliderController carouselProvider, String text) {
    if (text == words.elementAt(index).spanish) {
      carouselProvider.nextPage();
    } else {
      print("Fallo");
    }
  }
}
