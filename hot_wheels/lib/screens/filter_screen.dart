import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import '../controllers/filter_controller.dart';
import 'car_detail_screen.dart';

class FilterScreen extends StatelessWidget {
  const FilterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final text = theme.textTheme;
    final dimColor = text.bodySmall!.color!;

    final c = Get.find<FilterController>();

    return PopScope(
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) c.clearFilters();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Search'),
          actions: [
            Obx(() => c.hasFilters
                ? IconButton(icon: const Icon(Icons.clear_all), tooltip: 'Clear all', onPressed: c.clearFilters)
                : const SizedBox.shrink()),
          ],
        ),
        body: Column(
          children: [
            _buildSearchBar(c, cs, dimColor),
            _buildFilterChips(c, cs, theme, dimColor),
            Divider(height: 1, color: theme.dividerColor),
            Expanded(child: _buildResults(c, cs, theme, dimColor)),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(FilterController c, ColorScheme cs, Color dimColor) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: TextField(
        style: TextStyle(color: cs.onSurface),
        decoration: InputDecoration(
          hintText: 'Search by model name...',
          hintStyle: TextStyle(color: dimColor),
          filled: true,
          fillColor: cs.surface,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
          prefixIcon: Icon(Icons.search, color: dimColor),
          suffixIcon: Obx(() => c.query.isNotEmpty
              ? IconButton(icon: Icon(Icons.close, color: dimColor, size: 18), onPressed: () { c.query.value = ''; c.search(); })
              : const SizedBox.shrink()),
        ),
        onChanged: (v) {
          c.query.value = v;
          if (v.length >= 2 || v.isEmpty) c.search();
        },
      ),
    );
  }

  Widget _buildFilterChips(FilterController c, ColorScheme cs, ThemeData theme, Color dimColor) {
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
              onClear: () { c.selectedBrand.value = null; c.search(); },
              cs: cs, theme: theme, dimColor: dimColor,
            ),
            const SizedBox(width: 8),
            _buildDropdown(
              label: 'Series',
              value: c.selectedSeries.value,
              items: c.series,
              onChanged: (v) { c.selectedSeries.value = v; c.search(); },
              onClear: () { c.selectedSeries.value = null; c.search(); },
              cs: cs, theme: theme, dimColor: dimColor,
            ),
            const SizedBox(width: 8),
            _buildDropdown(
              label: 'Year',
              value: c.selectedYear.value,
              items: c.years,
              onChanged: (v) { c.selectedYear.value = v; c.search(); },
              onClear: () { c.selectedYear.value = null; c.search(); },
              cs: cs, theme: theme, dimColor: dimColor,
            ),
          ],
        ),
      );
    });
  }

  Widget _buildDropdown<T>({
    required String label,
    required T? value,
    required List<T> items,
    required void Function(T?) onChanged,
    required VoidCallback onClear,
    required ColorScheme cs,
    required ThemeData theme,
    required Color dimColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: value != null ? cs.primary : theme.dividerColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (value != null)
            GestureDetector(
              onTap: onClear,
              child: Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Icon(Icons.close, color: dimColor, size: 14),
              ),
            ),
          DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              hint: Text(label, style: TextStyle(color: value != null ? cs.primary : dimColor, fontSize: 13)),
              style: TextStyle(color: cs.onSurface, fontSize: 13),
              dropdownColor: theme.cardTheme.color ?? cs.surface,
              icon: Icon(Icons.arrow_drop_down, color: dimColor),
              items: [
                DropdownMenuItem<T>(value: null, child: Text('All $label', style: TextStyle(color: dimColor, fontSize: 13))),
                ...items.map((item) => DropdownMenuItem<T>(
                  value: item,
                  child: SizedBox(width: 140, child: Text('$item', style: const TextStyle(fontSize: 13), overflow: TextOverflow.ellipsis)),
                )),
              ],
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResults(FilterController c, ColorScheme cs, ThemeData theme, Color dimColor) {
    return Obx(() {
      if (c.searching.value) return const Center(child: CircularProgressIndicator());
      if (c.results.isEmpty) {
        return Center(
          child: Text(c.hasFilters ? 'No results' : 'Use filters to search',
            style: TextStyle(color: dimColor)),
        );
      }
      return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: c.results.length,
        itemBuilder: (ctx, i) {
          final car = c.results[i];
          return Card(
            color: theme.cardTheme.color ?? cs.surface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: car.imageUrl != null
                    ? CachedNetworkImage(imageUrl: car.imageUrl!, width: 50, height: 50, fit: BoxFit.cover)
                    : Container(width: 50, height: 50, color: theme.dividerColor, child: Icon(Icons.directions_car, color: dimColor)),
              ),
              title: Text(car.modelName, style: TextStyle(color: cs.onSurface, fontWeight: FontWeight.w500, fontSize: 14)),
              subtitle: Text('${car.year} · ${car.series ?? "No series"}', style: TextStyle(color: dimColor, fontSize: 11)),
              trailing: Text('#${car.displayNumber}', style: TextStyle(color: dimColor, fontSize: 11)),
              onTap: () => Get.to(() => CarDetailScreen(car: car)),
            ),
          );
        },
      );
    });
  }
}
