import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';

class ClockViewmodel extends ChangeNotifier {
  CountDownController countDownController = CountDownController();
  Color fillColor = Colors.green;
  Color ringColor = Colors.greenAccent;

  final int segundos = 10;

  void onChangeCountdowm(String? value) {
    var num = int.parse(value!);

    switch (num) {
      case < 4:
        fillColor = Colors.red;
        ringColor = Colors.orangeAccent;
        break;
      case < 6:
        fillColor = Colors.orange;
        ringColor = Colors.lime;
        break;
      default:
        fillColor = Colors.green;
        ringColor = Colors.greenAccent;
    }

    Future.microtask(() => notifyListeners());
  }
}
