import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import '../services/supabase_service.dart';
import '../controllers/filter_controller.dart';
import '../theme/hw_theme.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Brands'),
        actions: [
          IconButton(
            icon: Icon(_gridMode ? Icons.view_list : Icons.grid_view, color: Colors.white),
            tooltip: _gridMode ? 'List view' : 'Grid view',
            onPressed: () => setState(() => _gridMode = !_gridMode),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _brands == null || _brands!.isEmpty
              ? const Center(child: Text('No brands found', style: TextStyle(color: Colors.white38)))
              : _gridMode ? _buildGrid() : _buildList(),
    );
  }

  void _openBrand(BrandInfo b) {
    final c = Get.find<FilterController>();
    c.selectedBrand.value = b.name;
    c.search();
    Get.to(() => const FilterScreen());
  }

  Widget _buildGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 0.85),
      itemCount: _brands!.length,
      itemBuilder: (ctx, i) {
        final b = _brands![i];
        return GestureDetector(
          onTap: () => _openBrand(b),
          child: Container(
            decoration: BoxDecoration(color: HwTheme.card, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white10)),
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
                    child: b.imageUrl != null
                        ? CachedNetworkImage(imageUrl: b.imageUrl!, fit: BoxFit.cover, width: double.infinity)
                        : Container(color: Colors.white12, child: const Icon(Icons.directions_car, color: Colors.white38)),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(b.name, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600), maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center),
                        const SizedBox(height: 2),
                        Text('${b.count} cars', style: const TextStyle(color: Colors.white38, fontSize: 10)),
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

  Widget _buildList() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _brands!.length,
      itemBuilder: (ctx, i) {
        final b = _brands![i];
        return Card(
          color: HwTheme.card,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: b.imageUrl != null
                  ? CachedNetworkImage(imageUrl: b.imageUrl!, width: 56, height: 56, fit: BoxFit.cover)
                  : Container(width: 56, height: 56, color: Colors.white12, child: const Icon(Icons.directions_car, color: Colors.white38)),
            ),
            title: Text(b.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
            subtitle: Text('${b.count} cars', style: const TextStyle(color: Colors.white54, fontSize: 12)),
            trailing: const Icon(Icons.chevron_right, color: Colors.white24),
            onTap: () => _openBrand(b),
          ),
        );
      },
    );
  }
}
