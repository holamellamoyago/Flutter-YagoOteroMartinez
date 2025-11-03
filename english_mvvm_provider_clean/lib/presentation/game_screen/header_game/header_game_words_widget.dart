import 'package:english_mvvm_provider_clean/config/app_colors.dart';
import 'package:english_mvvm_provider_clean/data/strings/app_strings.dart';
import 'package:english_mvvm_provider_clean/data/viewmodel/carousel_viewmodel.dart';
import 'package:english_mvvm_provider_clean/data/viewmodel/words_viewmodel.dart';
import 'package:english_mvvm_provider_clean/presentation/game_screen/header_game/game_timer_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HeaderGameWidget extends StatelessWidget {
  const HeaderGameWidget({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
    required this.wordsProvider,
    required this.carouselProvider,
  });

  final double screenHeight;
  final double screenWidth;
  final WordsViewModel wordsProvider;
  final CarouselViewmodel carouselProvider;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () => openAlertDialog(context),
              icon: Icon(Icons.close),
            ),
            GameTimerWidget(),
            IconButton(onPressed: () => null, icon: Icon(Icons.settings)),
          ],
        ),
        AnimatedContainer(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: AppColors.primaryColor,
          ),
          duration: Duration(milliseconds: 500),
          height: screenHeight * 0.01,
          width:
              screenWidth *
              (carouselProvider.index / wordsProvider.words!.length),
        ),
      ],
    );
  }

  openAlertDialog(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: AppColors.primaryColor,
      useSafeArea: true,
      isDismissible: true,
      elevation: 10,
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          color: AppColors.primaryColor,
          height: screenHeight * 0.15,
          child: Column(
            spacing: 8,
            children: [
              Text(
                "Are you sure that do you want to exit?",
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 24),
              ),
              Row(
                spacing: 8,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FilledButton(
                    onPressed: () => context.pop(),
                    child: Text(
                      "Continue playing",
                      style: TextStyle(color: Colors.black),
                    ),
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.white),
                    ),
                  ),
                  OutlinedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.white),
                    ),
                    onPressed: () => context.go(AppStrings.mainHomeScreen),
                    child: Text("Exit", style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    // showDialog(
    //   context: context,
    //   builder: (context) => AlertDialog.adaptive(
    //     titlePadding: EdgeInsets.only(bottom: 24),
    //     title: Text("Are you sure that do you want to exit?"),
    //     actions: [
    //       FilledButton(onPressed: () => null, child: Text("Continue playing")),
    //       OutlinedButton(
    //         onPressed: () => null,
    //         child: Text("Exit", style: TextStyle(color: Colors.red)),
    //       ),
    //     ],
    //   ),
    // );
  }
}
