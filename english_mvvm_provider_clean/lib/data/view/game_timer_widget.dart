import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:english_mvvm_provider_clean/data/viewmodel/clock_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameTimerWidget extends StatelessWidget {
  const GameTimerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var clockProvider = context.watch<ClockViewmodel>();

    return Row(
      children: [
        CircularCountDownTimer(
          controller: clockProvider.countDownController,
          onComplete: () => clockProvider.openDialog(context),
          onChange: (value) => clockProvider.onChangeCountdowm(value),
          width: 50,
          height: 50,
          duration: 1,
          fillColor: clockProvider.fillColor,
          ringColor: clockProvider.ringColor,
          isReverse: true,
          isReverseAnimation: true,
          strokeCap: StrokeCap.butt,
        ),
        FilledButton(onPressed: () => 
        clockProvider.openDialog(context), child: Text(""))
      ],
    );
  }
}
