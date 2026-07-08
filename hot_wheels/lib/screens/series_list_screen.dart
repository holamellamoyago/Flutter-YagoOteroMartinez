import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import '../services/supabase_service.dart';
import '../controllers/filter_controller.dart';
import '../theme/hw_theme.dart';
import 'filter_screen.dart';

class SeriesListScreen extends StatefulWidget {
  const SeriesListScreen({super.key});

  @override
  State<SeriesListScreen> createState() => _SeriesListScreenState();
}

class _SeriesListScreenState extends State<SeriesListScreen> {
  final _service = SupabaseService();
  List<SeriesInfo>? _series;
  bool _loading = true;
  bool _gridMode = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final series = await _service.getSeriesWithStats();
      if (mounted) setState(() { _series = series; _loading = false; });
    } catch (_) {
      if (mounted) setState(() { _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Series'),
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
          : _series == null || _series!.isEmpty
              ? const Center(child: Text('No series found', style: TextStyle(color: Colors.white38)))
              : _gridMode ? _buildGrid() : _buildList(),
    );
  }

  void _openSeries(SeriesInfo s) {
    final c = Get.find<FilterController>();
    c.selectedSeries.value = s.name;
    c.search();
    Get.to(() => const FilterScreen());
  }

  Widget _buildGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 1.3),
      itemCount: _series!.length,
      itemBuilder: (ctx, i) {
        final s = _series![i];
        return GestureDetector(
          onTap: () => _openSeries(s),
          child: Container(
            decoration: BoxDecoration(color: HwTheme.card, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white10)),
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
                    child: s.imageUrl != null
                        ? CachedNetworkImage(imageUrl: s.imageUrl!, fit: BoxFit.cover, width: double.infinity)
                        : Container(color: Colors.white12, child: const Icon(Icons.directions_car, color: Colors.white38)),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(s.name, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600), maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center),
                        const SizedBox(height: 2),
                        Text('${s.count} cars', style: const TextStyle(color: Colors.white38, fontSize: 10)),
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
      itemCount: _series!.length,
      itemBuilder: (ctx, i) {
        final s = _series![i];
        return Card(
          color: HwTheme.card,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: s.imageUrl != null
                  ? CachedNetworkImage(imageUrl: s.imageUrl!, width: 56, height: 56, fit: BoxFit.cover)
                  : Container(width: 56, height: 56, color: Colors.white12, child: const Icon(Icons.directions_car, color: Colors.white38)),
            ),
            title: Text(s.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
            subtitle: Text('${s.count} cars', style: const TextStyle(color: Colors.white54, fontSize: 12)),
            trailing: const Icon(Icons.chevron_right, color: Colors.white24),
            onTap: () => _openSeries(s),
          ),
        );
      },
    );
  }
}
