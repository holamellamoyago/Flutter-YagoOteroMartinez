import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CarouselViewmodel extends ChangeNotifier {
  CarouselSliderController controller = CarouselSliderController();
  int points = 0;

  nextPage() => controller.nextPage(
    duration: const Duration(milliseconds: 300),
    curve: Curves.linear,
  );

  addPoints() {
    points += 100;
    nextPage();
  }
}
