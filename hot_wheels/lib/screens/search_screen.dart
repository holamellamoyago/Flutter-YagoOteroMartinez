import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import '../controllers/app_controllers.dart';
import '../models/hot_wheels_car.dart';
import '../theme/hw_theme.dart';
import 'car_detail_screen.dart';

class SearchScreen extends GetView<CarSearchController> {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CarSearchController());
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Search cars...',
            hintStyle: TextStyle(color: Colors.white38),
            border: InputBorder.none,
          ),
          onSubmitted: (q) => controller.search(q),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.search, color: HwTheme.orange), onPressed: () {}),
        ],
      ),
      body: Obx(() {
        if (controller.searching.value) return const Center(child: CircularProgressIndicator());
        if (controller.results.isEmpty && controller.query.isNotEmpty) {
          return Center(child: Text('No results for "${controller.query.value}"', style: Get.textTheme.bodyMedium));
        }
        if (controller.results.isEmpty) {
          return Center(child: Text('Type to search', style: Get.textTheme.bodyMedium));
        }
        return _buildResults(controller.results);
      }),
    );
  }

  Widget _buildResults(List<HotWheelsCar> cars) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: cars.length,
      itemBuilder: (ctx, i) {
        final car = cars[i];
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: car.imageUrl != null
                  ? CachedNetworkImage(imageUrl: car.imageUrl!, width: 50, height: 50, fit: BoxFit.cover)
                  : Container(width: 50, height: 50, color: Colors.white12, child: const Icon(Icons.directions_car, color: Colors.white38)),
            ),
            title: Text(car.modelName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
            subtitle: Text('${car.year} · ${car.series ?? "No series"}', style: const TextStyle(color: Colors.white54, fontSize: 12)),
            trailing: Text('#${car.displayNumber}', style: const TextStyle(color: Colors.white38, fontSize: 11)),
            onTap: () => Get.to(() => CarDetailScreen(car: car)),
          ),
        );
      },
    );
  }
}
