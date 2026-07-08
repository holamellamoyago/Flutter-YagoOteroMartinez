import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import '../controllers/app_controllers.dart';
import '../models/hot_wheels_car.dart';
import '../theme/hw_theme.dart';
import 'car_detail_screen.dart';

class CarListScreen extends StatelessWidget {
  final int year;
  const CarListScreen({super.key, required this.year});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(CarsController(year));
    return Scaffold(
      appBar: AppBar(title: Text(year.toString())),
      body: Obx(() {
        if (c.loading.value) return const Center(child: CircularProgressIndicator());
        if (c.cars.isEmpty) return Center(child: Text('No cars found', style: Get.textTheme.bodyMedium));
        return _buildGrid(c.cars);
      }),
    );
  }

  Widget _buildGrid(List<HotWheelsCar> cars) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.75,
      ),
      itemCount: cars.length,
      itemBuilder: (ctx, i) => _CarCard(car: cars[i]),
    );
  }
}

class _CarCard extends StatelessWidget {
  final HotWheelsCar car;
  const _CarCard({required this.car});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => CarDetailScreen(car: car)),
      child: Container(
        decoration: BoxDecoration(
          color: HwTheme.card,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(9)),
                child: car.imageUrl != null
                    ? CachedNetworkImage(imageUrl: car.imageUrl!, fit: BoxFit.cover, placeholder: (_, _) => const Center(child: Icon(Icons.directions_car, color: Colors.white24, size: 32)), errorWidget: (_, _, _) => const Icon(Icons.broken_image, color: Colors.white24))
                    : const Icon(Icons.directions_car, color: Colors.white24, size: 32),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(car.modelName, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w500)),
                    if (car.series != null)
                      Text(car.series!, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 8, color: HwTheme.orange)),
                    const Spacer(),
                    Text('#${car.displayNumber}', style: const TextStyle(fontSize: 9, color: Colors.white38)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
