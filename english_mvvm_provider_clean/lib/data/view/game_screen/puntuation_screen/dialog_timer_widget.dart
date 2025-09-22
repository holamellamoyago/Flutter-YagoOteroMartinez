import 'package:english_mvvm_provider_clean/config/app_shadows.dart';
import 'package:english_mvvm_provider_clean/data/strings/app_strings.dart';
import 'package:english_mvvm_provider_clean/data/viewmodel/carousel_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class DialogTimerWidget extends StatelessWidget {
  const DialogTimerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<CarouselViewmodel>(context, listen: false);
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
                AppShadows.shadow
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
                    _rowPoints(
                      context,
                      AppStrings.cardTitleNew,
                      provider.points,
                    ),
                    Container(
                      height: 1,
                      color: Colors.grey,
                      margin: EdgeInsets.all(8),
                    ),
                    _rowPoints(context, AppStrings.cardTitleTotal, 999),
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
          // TODO 
          onPressed: () => context.go('/'),
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
