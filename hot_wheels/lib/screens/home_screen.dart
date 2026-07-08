import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/app_controllers.dart';
import '../controllers/filter_controller.dart';
import '../theme/hw_theme.dart';
import 'car_list_screen.dart';
import 'filter_screen.dart';
import 'brand_list_screen.dart';
import 'series_list_screen.dart';
import 'login_screen.dart';

class HomeScreen extends GetView<YearsController> {
  const HomeScreen({super.key});

  FilterController get _filter => Get.find<FilterController>();

  @override
  Widget build(BuildContext context) {
    Get.put(YearsController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hot Wheels'),
        actions: [
          IconButton(icon: const Icon(Icons.person_outline), tooltip: 'Account', onPressed: () => Get.to(() => const LoginScreen())),
          IconButton(icon: const Icon(Icons.search), onPressed: () => Get.to(() => const FilterScreen())),
        ],
      ),
      body: Obx(() {
        if (controller.loading.value) return const Center(child: CircularProgressIndicator());
        if (controller.error.value != null) return _buildError();
        return _buildSections();
      }),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.error_outline, color: HwTheme.flame, size: 48),
        const SizedBox(height: 12),
        Text('Error loading data', style: Get.textTheme.bodyMedium),
        const SizedBox(height: 12),
        ElevatedButton(onPressed: () => controller.load(), child: const Text('Retry')),
      ]),
    );
  }

  Widget _buildSections() {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      children: [
        _SectionHeader(title: 'By Year', subtitle: '${controller.years.length} years', onSeeAll: () {}),
        _YearRow(years: controller.years),
        const SizedBox(height: 24),

        _SectionHeader(title: 'By Brand', subtitle: '${_filter.brands.length} brands', onSeeAll: () => Get.to(() => const BrandListScreen())),
        _BrandRow(brands: _filter.brands, onTap: (b) => _openFilter(brand: b)),
        const SizedBox(height: 24),

        _SectionHeader(title: 'By Series', subtitle: '${_filter.series.length} series', onSeeAll: () => Get.to(() => const SeriesListScreen())),
        _SeriesRow(series: _filter.series, onTap: (s) => _openFilter(series: s)),
        const SizedBox(height: 80),
      ],
    );
  }

  void _openFilter({String? brand, String? series}) {
    if (brand != null) { _filter.selectedBrand.value = brand; _filter.search(); }
    if (series != null) { _filter.selectedSeries.value = series; _filter.search(); }
    Get.to(() => const FilterScreen());
  }
}

// ── Section header ──

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onSeeAll;
  const _SectionHeader({required this.title, required this.subtitle, required this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: HwTheme.orange.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(10)), child: Text(subtitle, style: const TextStyle(color: HwTheme.orange, fontSize: 11))),
          const Spacer(),
          GestureDetector(onTap: onSeeAll, child: const Text('See all', style: TextStyle(color: HwTheme.orange, fontSize: 13))),
        ],
      ),
    );
  }
}

// ── Year row ──

class _YearRow extends StatelessWidget {
  final List<int> years;
  const _YearRow({required this.years});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: years.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (ctx, i) {
          final y = years[i];
          return GestureDetector(
            onTap: () => Get.to(() => CarListScreen(year: y)),
            child: Container(
              width: 80,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [HwTheme.orange, HwTheme.flame], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Text(y.toString(), style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          );
        },
      ),
    );
  }
}

// ── Brand row ──

class _BrandRow extends StatelessWidget {
  final List<String> brands;
  final void Function(String) onTap;
  const _BrandRow({required this.brands, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: brands.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (ctx, i) {
          final b = brands[i];
          return GestureDetector(
            onTap: () => onTap(b),
            child: Container(
              width: 110,
              decoration: BoxDecoration(color: HwTheme.card, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white10)),
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(b, style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis),
            ),
          );
        },
      ),
    );
  }
}

// ── Series row ──

class _SeriesRow extends StatelessWidget {
  final List<String> series;
  final void Function(String) onTap;
  const _SeriesRow({required this.series, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: series.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (ctx, i) {
          final s = series[i];
          return GestureDetector(
            onTap: () => onTap(s),
            child: Container(
              width: 130,
              decoration: BoxDecoration(color: HwTheme.card, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white10)),
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(s, style: const TextStyle(color: Colors.white70, fontSize: 11), maxLines: 2, overflow: TextOverflow.ellipsis),
            ),
          );
        },
      ),
    );
  }
}
