import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';

class CarouselViewmodel extends ChangeNotifier {
  final CarouselSliderController controller = CarouselSliderController();
  int points = 0;
  int _index = 0;

  int get index => _index;

  nextPage() => controller.nextPage(
    duration: const Duration(milliseconds: 300),
    curve: Curves.linear,
  );

  addPoints() {
    points += 100;
    nextPage();
  }

  addIndex() {
    _index++;
    notifyListeners();
  }
}
