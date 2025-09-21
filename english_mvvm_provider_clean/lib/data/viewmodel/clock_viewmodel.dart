import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:english_mvvm_provider_clean/data/strings/app_strings.dart';
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

  void openDialog(BuildContext context) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => DialogTimerWidget(),
    );
  }
}

class DialogTimerWidget extends StatelessWidget {
  const DialogTimerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;

    return AlertDialog(
      content: SizedBox(
        height: screenHeight * 0.4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.emoji_events_outlined,
              color: Color(0xFFDAA520),
              size: screenHeight * 0.1,
              shadows: [
                Shadow(
                  offset: Offset(4, 4),
                  color: Colors.grey,
                  blurRadius: 10,
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              AppStrings.headLineDialogTime,
              style: Theme.of(context).textTheme.headlineLarge,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              AppStrings.titleDialog,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 16),
            Card(
              borderOnForeground: true,
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    _rowPoints(context, AppStrings.cardTitleNew, 999),
                    Container(
                      height: 1,
                      color: Colors.grey,
                      margin: EdgeInsets.all(8),
                    ),
                    _rowPoints(context, AppStrings.cardTitleNew, 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        FilledButton.icon(
          icon: Icon(Icons.refresh),
          onPressed: () => {},
          label: Text(AppStrings.textButtonDialog),
        ),
      ],
    );
  }

  Widget _rowPoints(BuildContext context, String title, int points) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: Theme.of(context).textTheme.labelMedium),
        Text(points.toString(), style: Theme.of(context).textTheme.titleLarge),
      ],
    );
  }
}
