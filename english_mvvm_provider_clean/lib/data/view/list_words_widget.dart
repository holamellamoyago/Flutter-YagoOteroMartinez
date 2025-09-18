import 'package:carousel_slider/carousel_slider.dart';
import 'package:english_mvvm_provider_clean/data/viewmodel/words_viewmodel.dart';
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
        itemBuilder: (context, index, realIndex) =>
            Text(provider.words!.elementAt(index).spanish),
        options: CarouselOptions(),
      ),
    );
  }
  
}



