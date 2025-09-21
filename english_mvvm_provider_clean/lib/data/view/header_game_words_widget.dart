import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';

class HeaderGameWidget extends StatelessWidget {
  const HeaderGameWidget({super.key, required this.screenHeight});

  final double screenHeight;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircularCountDownTimer(
          width: 50,
          height: 50,
          duration: 10,
          fillColor: Colors.blue,
          ringColor: Colors.lightBlueAccent,
          isReverse: true,
          isReverseAnimation: true,
          strokeCap: StrokeCap.butt,
        ),
      ],
    );
  }
}
