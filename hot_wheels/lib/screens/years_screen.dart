import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/app_controllers.dart';
import '../theme/hw_theme.dart';
import 'car_list_screen.dart';
import 'filter_screen.dart';
import 'login_screen.dart';

class YearsScreen extends GetView<YearsController> {
  const YearsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(YearsController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hot Wheels'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            tooltip: 'Account',
            onPressed: () => Get.to(() => const LoginScreen()),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => Get.to(() => const FilterScreen()),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.loading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.error.value != null) {
          return _buildError();
        }
        return _buildGrid();
      }),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, color: HwTheme.flame, size: 48),
          const SizedBox(height: 12),
          Text('Error loading data', style: Get.textTheme.bodyMedium),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => controller.load(),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.2,
      ),
      itemCount: controller.years.length,
      itemBuilder: (ctx, i) {
        final year = controller.years[i];
        return GestureDetector(
          onTap: () => Get.to(() => CarListScreen(year: year)),
          child: Container(
            decoration: BoxDecoration(
              color: HwTheme.card,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: HwTheme.orange.withValues(alpha: 0.3)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(year.toString(), style: Get.textTheme.titleLarge?.copyWith(color: HwTheme.orange)),
              ],
            ),
          ),
        );
      },
    );
  }
}
