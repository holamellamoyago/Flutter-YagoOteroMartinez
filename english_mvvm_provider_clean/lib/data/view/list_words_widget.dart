import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:english_mvvm_provider_clean/data/viewmodel/words_viewmodel.dart';
import 'package:english_mvvm_provider_clean/domain/entities/word.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListWordsWidget extends StatelessWidget {
  const ListWordsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WordsViewModel>();

    // return Expanded(
    //   child: ListView.builder(
    //     scrollDirection: Axis.horizontal,
    //     itemCount: provider.words!.length,
    //     itemBuilder: (context, index) =>
    //         Text(provider.words!.elementAt(index).english),
    //   ),
    // );

    return Expanded(
      child: CarouselSlider.builder(
        itemCount: provider.words!.length,
        itemBuilder: (context, index, realIndex) => GridTestWidget(words: provider.words!, index: index),
        options: CarouselOptions(enlargeCenterPage: true),
      ),
    );
  }
}

class GridTestWidget extends StatelessWidget {
  final List<Word> words;
  final int index;

  const GridTestWidget({super.key, required this.words, required this.index});

  @override
  Widget build(BuildContext context) {
    var word = words.elementAt(index);
    var random = Random();

    final answers = List<String>.generate(
      4,
      (index) => words[random.nextInt(words.length)].spanish,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("What does ${word.english} mean?"),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _colorContainer(answers[0], Colors.redAccent),
            _colorContainer(answers[1], Colors.blueAccent),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _colorContainer(answers[2], Colors.yellowAccent),
            _colorContainer(answers[3], Colors.greenAccent),
          ],
        ),
      ],
    );
  }

  // String randomAnswer() {
  //   var rdm = Random().nextInt(words.length);
  //   return words.elementAt(rdm).spanish;
  // }

  Widget _colorContainer(String text, Color color) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(child: Text(text)),
      ),
    );
  }
}
