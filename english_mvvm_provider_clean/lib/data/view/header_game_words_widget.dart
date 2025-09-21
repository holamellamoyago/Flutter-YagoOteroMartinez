import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:english_mvvm_provider_clean/data/view/game_timer_widget.dart';
import 'package:flutter/material.dart';

class HeaderGameWidget extends StatelessWidget {
  const HeaderGameWidget({super.key, required this.screenHeight});

  final double screenHeight;
  // final Color fillColor = Colors.green;
  // final Color ringColor = Colors.greenAccent;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GameTimerWidget()
      ],
    );
  }

  void _onChangeCountdowm(){

  }
}
