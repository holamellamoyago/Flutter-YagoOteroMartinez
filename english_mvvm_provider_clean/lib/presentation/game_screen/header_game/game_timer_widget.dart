import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:english_mvvm_provider_clean/data/viewmodel/clock_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameTimerWidget extends StatelessWidget {
  const GameTimerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO Revisar si esto puede ser un listen: false
    var clockProvider = context.watch<ClockViewmodel>();

    return CircularCountDownTimer(
      controller: clockProvider.countDownController,
      onComplete: () => clockProvider.openDialog(context),
      onChange: (value) => clockProvider.onChangeCountdowm(value),
      width: 50,
      height: 50,
      duration: clockProvider.segundos,
      fillColor: clockProvider.fillColor,
      ringColor: clockProvider.ringColor,
      isReverse: true,
      isReverseAnimation: true,
      strokeCap: StrokeCap.butt,
    );
  }
}
