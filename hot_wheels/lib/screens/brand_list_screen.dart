import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import '../services/supabase_service.dart';
import '../controllers/filter_controller.dart';
import 'filter_screen.dart';

class BrandListScreen extends StatefulWidget {
  const BrandListScreen({super.key});

  @override
  State<BrandListScreen> createState() => _BrandListScreenState();
}

class _BrandListScreenState extends State<BrandListScreen> {
  final _service = SupabaseService();
  List<BrandInfo>? _brands;
  bool _loading = true;
  bool _gridMode = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final brands = await _service.getBrandsWithStats();
      if (mounted) setState(() { _brands = brands; _loading = false; });
    } catch (_) {
      if (mounted) setState(() { _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final text = theme.textTheme;
    final dimColor = text.bodySmall!.color!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Brands'),
        actions: [
          IconButton(
            icon: Icon(_gridMode ? Icons.view_list : Icons.grid_view, color: cs.onSurface),
            tooltip: _gridMode ? 'List view' : 'Grid view',
            onPressed: () => setState(() => _gridMode = !_gridMode),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _brands == null || _brands!.isEmpty
              ? Center(child: Text('No brands found', style: TextStyle(color: dimColor)))
              : _gridMode ? _buildGrid(theme, cs, dimColor) : _buildList(theme, cs, dimColor),
    );
  }

  void _openBrand(BrandInfo b) {
    final c = Get.find<FilterController>();
    c.selectedBrand.value = b.name;
    c.search();
    Get.to(() => const FilterScreen());
  }

  Widget _buildGrid(ThemeData theme, ColorScheme cs, Color dimColor) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 0.85),
      itemCount: _brands!.length,
      itemBuilder: (ctx, i) {
        final b = _brands![i];
        return GestureDetector(
          onTap: () => _openBrand(b),
          child: Container(
            decoration: BoxDecoration(color: theme.cardTheme.color ?? cs.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: theme.dividerColor)),
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
                    child: b.imageUrl != null
                        ? CachedNetworkImage(imageUrl: b.imageUrl!, fit: BoxFit.cover, width: double.infinity)
                        : Container(color: theme.dividerColor, child: Icon(Icons.directions_car, color: dimColor)),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(b.name, style: TextStyle(color: cs.onSurface, fontSize: 11, fontWeight: FontWeight.w600), maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center),
                        const SizedBox(height: 2),
                        Text('${b.count} cars', style: TextStyle(color: dimColor, fontSize: 10)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildList(ThemeData theme, ColorScheme cs, Color dimColor) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _brands!.length,
      itemBuilder: (ctx, i) {
        final b = _brands![i];
        return Card(
          color: theme.cardTheme.color ?? cs.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: b.imageUrl != null
                  ? CachedNetworkImage(imageUrl: b.imageUrl!, width: 56, height: 56, fit: BoxFit.cover)
                  : Container(width: 56, height: 56, color: theme.dividerColor, child: Icon(Icons.directions_car, color: dimColor)),
            ),
            title: Text(b.name, style: TextStyle(color: cs.onSurface, fontWeight: FontWeight.w600)),
            subtitle: Text('${b.count} cars', style: TextStyle(color: dimColor, fontSize: 12)),
            trailing: Icon(Icons.chevron_right, color: dimColor),
            onTap: () => _openBrand(b),
          ),
        );
      },
    );
  }
}
