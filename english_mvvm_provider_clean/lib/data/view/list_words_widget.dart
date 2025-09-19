import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:english_mvvm_provider_clean/data/strings/app_strings.dart';
import 'package:english_mvvm_provider_clean/data/viewmodel/carousel_viewmodel.dart';
import 'package:english_mvvm_provider_clean/data/viewmodel/words_viewmodel.dart';
import 'package:english_mvvm_provider_clean/domain/entities/word.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ListWordsWidget extends StatelessWidget {
  const ListWordsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final wordsProvider = context.watch<WordsViewModel>();
    final carouselProvider = context.watch<CarouselViewmodel>();

    // return Expanded(
    //   child: ListView.builder(
    //     scrollDirection: Axis.horizontal,
    //     itemCount: provider.words!.length,
    //     itemBuilder: (context, index) =>
    //         Text(provider.words!.elementAt(index).english),
    //   ),
    // );

    return CarouselSlider.builder(
      carouselController: carouselProvider.controller,
      itemCount: wordsProvider.words!.length,
      itemBuilder: (context, index, realIndex) =>
          GridTestWidget(words: wordsProvider.words!, index: index, carouselProvider: carouselProvider.controller,),
      options: CarouselOptions(enlargeCenterPage: true),
    );
  }
}

class GridTestWidget extends StatelessWidget {
  final List<Word> words;
  final int index;
  final CarouselSliderController carouselProvider;

  const GridTestWidget({super.key, required this.words, required this.index, required this.carouselProvider});

  @override
  Widget build(BuildContext context) {
    var word = words.elementAt(index);
    var random = Random();
    var strings = AppStrings();

    var answers = _generateUniqueRandomNumber();

    answers[random.nextInt(answers.length - 1)] = word.spanish;

    return Column(
      children: [
        Text(strings.question_1 + word.english + strings.question_2, style: Theme.of(context).textTheme.headlineLarge,),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _colorContainer(carouselProvider, answers[0], Colors.redAccent),
              SizedBox(width: 16),
              _colorContainer(carouselProvider, answers[1], Colors.blueAccent),
            ],
          ),
        ),
        SizedBox(height: 16),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _colorContainer(
                carouselProvider,
                answers[2],
                Colors.yellowAccent,
              ),
              SizedBox(width: 16),
              _colorContainer(carouselProvider, answers[3], Colors.greenAccent),
            ],
          ),
        ),
      ],
    );
  }

  Widget _colorContainer(
    CarouselSliderController carouselProvider,
    String text,
    Color color,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: () => _checkAnswer(carouselProvider, text),
        child: Container(
          decoration: BoxDecoration(
            color: color,
            border: Border.all(color: Colors.grey, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(child: Text(text)),
        ),
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
