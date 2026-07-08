import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import '../models/hot_wheels_car.dart';
import '../theme/hw_theme.dart';

class CarDetailScreen extends StatelessWidget {
  final HotWheelsCar car;
  const CarDetailScreen({super.key, required this.car});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(car.modelName)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: car.imageUrl != null
                  ? CachedNetworkImage(imageUrl: car.imageUrl!, fit: BoxFit.contain, placeholder: (_, _) => const Center(child: CircularProgressIndicator()), errorWidget: (_, _, _) => const Icon(Icons.broken_image, color: Colors.white24))
                  : Container(color: HwTheme.surface, child: const Icon(Icons.directions_car, size: 80, color: Colors.white24)),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(car.modelName, style: Get.textTheme.titleLarge),
                  const SizedBox(height: 4),
                  if (car.series != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: HwTheme.orange.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(6)),
                      child: Text(car.series!, style: const TextStyle(color: HwTheme.orange, fontSize: 13)),
                    ),
                  const SizedBox(height: 20),
                  _detailRow('Year', car.year.toString()),
                  _detailRow('Toy #', car.displayNumber),
                  if (car.seriesNum != null) _detailRow('Series #', car.seriesNum!),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(width: 100, child: Text(label, style: Get.textTheme.bodyMedium)),
          Expanded(child: Text(value, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }
}
