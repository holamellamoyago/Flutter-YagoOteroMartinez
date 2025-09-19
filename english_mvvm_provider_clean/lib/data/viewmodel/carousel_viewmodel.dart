import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';

class CarouselViewmodel extends ChangeNotifier {
  CarouselSliderController controller = CarouselSliderController();

  nextPage() => controller.nextPage(
    duration: const Duration(milliseconds: 300),
    curve: Curves.linear,
  );
}
