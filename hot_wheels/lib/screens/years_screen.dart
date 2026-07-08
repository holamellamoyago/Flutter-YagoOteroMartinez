import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/app_controllers.dart';
import '../controllers/filter_controller.dart';
import '../theme/hw_theme.dart';
import 'car_list_screen.dart';
import 'filter_screen.dart';
import 'login_screen.dart';

class YearsScreen extends GetView<YearsController> {
  const YearsScreen({super.key});

  FilterController get _filter => Get.find<FilterController>();

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
        return _buildContent();
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
          ElevatedButton(onPressed: () => controller.load(), child: const Text('Retry')),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildFilterChips(),
        const Divider(height: 1, color: Colors.white12),
        Expanded(child: _buildYearGrid()),
      ],
    );
  }

  Widget _buildFilterChips() {
    return SizedBox(
      height: 44,
      child: Obx(() => ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        children: [
          ..._filter.brands.take(15).map((b) => Padding(
            padding: const EdgeInsets.only(right: 6),
            child: _Chip(
              label: b,
              onTap: () => _openFilterWith(brand: b),
            ),
          )),
          const SizedBox(width: 8),
          _Chip(
            label: 'Brands +',
            highlight: true,
            onTap: () => Get.to(() => const FilterScreen()),
          ),
          const SizedBox(width: 4),
          ...controller.years.take(7).map((y) => Padding(
            padding: const EdgeInsets.only(right: 6),
            child: _Chip(
              label: y.toString(),
              onTap: () => Get.to(() => CarListScreen(year: y)),
            ),
          )),
          _Chip(
            label: 'Years +',
            highlight: true,
            onTap: () => Get.to(() => const FilterScreen()),
          ),
        ],
      )),
    );
  }

  void _openFilterWith({String? brand}) {
    if (brand != null) {
      _filter.selectedBrand.value = brand;
      _filter.search();
    }
    Get.to(() => const FilterScreen());
  }

  Widget _buildYearGrid() {
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

class _Chip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool highlight;
  const _Chip({required this.label, required this.onTap, this.highlight = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: highlight ? HwTheme.orange.withValues(alpha: 0.15) : HwTheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: highlight ? HwTheme.orange.withValues(alpha: 0.4) : Colors.white12),
        ),
        child: Text(label, style: TextStyle(color: highlight ? HwTheme.orange : Colors.white70, fontSize: 12, fontWeight: FontWeight.w500)),
      ),
    );
  }
}
