import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import '../controllers/filter_controller.dart';
import '../theme/hw_theme.dart';
import 'car_detail_screen.dart';

class FilterScreen extends StatelessWidget {
  const FilterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<FilterController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        actions: [
          Obx(() => c.hasFilters
              ? IconButton(icon: const Icon(Icons.clear_all), tooltip: 'Clear', onPressed: c.clearFilters)
              : const SizedBox.shrink()),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(c),
          _buildFilterChips(c),
          const Divider(height: 1, color: Colors.white12),
          Expanded(child: _buildResults(c)),
        ],
      ),
    );
  }

  Widget _buildSearchBar(FilterController c) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: TextField(
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Search by model name...',
          hintStyle: const TextStyle(color: Colors.white38),
          filled: true,
          fillColor: HwTheme.surface,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
          prefixIcon: const Icon(Icons.search, color: Colors.white38),
          suffixIcon: Obx(() => c.query.isNotEmpty
              ? IconButton(icon: const Icon(Icons.close, color: Colors.white38, size: 18), onPressed: () { c.query.value = ''; c.search(); })
              : const SizedBox.shrink()),
        ),
        onChanged: (v) {
          c.query.value = v;
          if (v.length >= 2 || v.isEmpty) c.search();
        },
      ),
    );
  }

  Widget _buildFilterChips(FilterController c) {
    return Obx(() {
      if (c.loadingOptions.value) {
        return const Padding(padding: EdgeInsets.all(8), child: SizedBox(height: 40, child: Center(child: CircularProgressIndicator(strokeWidth: 2))));
      }
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            _buildDropdown(
              label: 'Brand',
              value: c.selectedBrand.value,
              items: c.brands,
              onChanged: (v) { c.selectedBrand.value = v; c.search(); },
            ),
            const SizedBox(width: 8),
            _buildDropdown(
              label: 'Series',
              value: c.selectedSeries.value,
              items: c.series,
              onChanged: (v) { c.selectedSeries.value = v; c.search(); },
            ),
            const SizedBox(width: 8),
            _buildDropdown(
              label: 'Year',
              value: c.selectedYear.value,
              items: c.years,
              onChanged: (v) { c.selectedYear.value = v; c.search(); },
            ),
          ],
        ),
      );
    });
  }

  Widget _buildDropdown<T>({required String label, required T? value, required List<T> items, required void Function(T?) onChanged}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(color: HwTheme.surface, borderRadius: BorderRadius.circular(8), border: Border.all(color: value != null ? HwTheme.orange : Colors.white12)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          hint: Text(label, style: const TextStyle(color: Colors.white38, fontSize: 13)),
          style: const TextStyle(color: Colors.white, fontSize: 13),
          dropdownColor: HwTheme.card,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.white38),
          items: [
            DropdownMenuItem<T>(value: null, child: Text('All $label', style: const TextStyle(color: Colors.white38, fontSize: 13))),
            ...items.map((item) => DropdownMenuItem<T>(value: item, child: SizedBox(width: 140, child: Text('$item', style: const TextStyle(fontSize: 13), overflow: TextOverflow.ellipsis)))),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildResults(FilterController c) {
    return Obx(() {
      if (c.searching.value) return const Center(child: CircularProgressIndicator());
      if (c.results.isEmpty) {
        return Center(
          child: Text(c.hasFilters ? 'No results' : 'Use filters to search',
            style: const TextStyle(color: Colors.white38)),
        );
      }
      return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: c.results.length,
        itemBuilder: (ctx, i) {
          final car = c.results[i];
          return Card(
            color: HwTheme.card,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: car.imageUrl != null
                    ? CachedNetworkImage(imageUrl: car.imageUrl!, width: 50, height: 50, fit: BoxFit.cover)
                    : Container(width: 50, height: 50, color: Colors.white12, child: const Icon(Icons.directions_car, color: Colors.white38)),
              ),
              title: Text(car.modelName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14)),
              subtitle: Text('${car.year} · ${car.series ?? "No series"}', style: const TextStyle(color: Colors.white54, fontSize: 11)),
              trailing: Text('#${car.displayNumber}', style: const TextStyle(color: Colors.white38, fontSize: 11)),
              onTap: () => Get.to(() => CarDetailScreen(car: car)),
            ),
          );
        },
      );
    });
  }
}
