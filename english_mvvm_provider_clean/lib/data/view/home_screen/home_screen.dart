import 'package:english_mvvm_provider_clean/data/view/game_screen/game_words_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: GameWordsWidget()));
  }
}
