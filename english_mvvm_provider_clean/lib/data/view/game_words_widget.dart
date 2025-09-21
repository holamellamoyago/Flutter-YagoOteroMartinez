import 'package:carousel_slider/carousel_slider.dart';
import 'package:english_mvvm_provider_clean/data/view/grid_answers.dart';
import 'package:english_mvvm_provider_clean/data/view/header_game_words_widget.dart';
import 'package:english_mvvm_provider_clean/data/viewmodel/carousel_viewmodel.dart';
import 'package:english_mvvm_provider_clean/data/viewmodel/words_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameWordsWidget extends StatelessWidget {
  const GameWordsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final wordsProvider = context.watch<WordsViewModel>();
    final carouselProvider = context.watch<CarouselViewmodel>();
    double screenHeight = MediaQuery.of(context).size.height;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        HeaderGameWidget(screenHeight: screenHeight),
        CarouselSlider.builder(
          disableGesture: true,
          carouselController: carouselProvider.controller,
          itemCount: wordsProvider.words!.length,
          itemBuilder: (context, index, realIndex) => GridTestWidget(
            words: wordsProvider.words!,
            index: index,
            carouselProvider: carouselProvider.controller,
          ),
          options: CarouselOptions(
            enlargeCenterPage: false,
            height: screenHeight * 0.36,
            viewportFraction: 1,
            scrollPhysics: NeverScrollableScrollPhysics(),
          ),
        ),
        SizedBox(height: screenHeight * 0.2),
      ],
    );
  }
}


