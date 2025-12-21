import 'package:carousel_slider/carousel_slider.dart';
import 'package:english_mvvm_provider_clean/config/app_colors.dart';
import 'package:english_mvvm_provider_clean/presentation/game_screen/body_game/grid_answers.dart';
import 'package:english_mvvm_provider_clean/presentation/game_screen/header_game/header_game_words_widget.dart';
import 'package:english_mvvm_provider_clean/data/viewmodel/carousel_viewmodel.dart';
import 'package:english_mvvm_provider_clean/data/viewmodel/words_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final WordsViewModel wordsProvider = Provider.of<WordsViewModel>(
      context,
      listen: true,
    );

    final CarouselViewmodel carouselProvider = Provider.of<CarouselViewmodel>(
      context,
      listen: true,
    );

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    carouselProvider.updateTotalPoints(wordsProvider.words!.length * 100);

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            HeaderGameWidget(
              screenHeight: screenHeight,
              screenWidth: screenWidth,
              carouselProvider: carouselProvider,
              wordsProvider: wordsProvider,
            ),
            CarouselSlider.builder(
              disableGesture: true,
              carouselController: carouselProvider.controller,
              itemCount: wordsProvider.words!.length,
              itemBuilder: (context, index, realIndex) {
                return GridTestWidget(
                  words: wordsProvider.words!,
                  index: index,
                  carouselProvider: carouselProvider,
                  wordsProvider: wordsProvider,
                );
              },
              options: CarouselOptions(
                enlargeCenterPage: false,
                height: screenHeight * 0.36,
                viewportFraction: 1,
                enableInfiniteScroll: false,
                scrollPhysics: NeverScrollableScrollPhysics(),
                onPageChanged: (index, reason) => carouselProvider.addIndex(),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Pregunta ${carouselProvider.index + 1} de ${wordsProvider.words!.length}",
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
