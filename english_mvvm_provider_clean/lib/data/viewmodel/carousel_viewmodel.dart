import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';

class CarouselViewmodel extends ChangeNotifier {
  final CarouselSliderController controller = CarouselSliderController();

  // Estos son los puntos que en un futuro cambiará la cifra dependendiendo de la dificultad
  final int points = 100;

  int currentPoints = 0;
  int totalPoints = 0;
  int _index = 0;

  int get index => _index;

  nextPage() => controller.nextPage(
    duration: const Duration(milliseconds: 300),
    curve: Curves.linear,
  );

  addPoints() {
    currentPoints += points;
    nextPage();
  }

  addIndex() {
    _index++;
    notifyListeners();
  }

  updateTotalPoints(int totalPoints) {
    if (totalPoints > 0) this.totalPoints = totalPoints;
  }

  subtractPoints() {
    if (totalPoints <= points) {
      currentPoints = 0;
      return;
    }

    currentPoints = currentPoints - points;
  }
}
