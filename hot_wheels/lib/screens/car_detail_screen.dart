import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import '../models/hot_wheels_car.dart';
import '../services/supabase_service.dart';
import '../theme/hw_theme.dart';

class CarDetailScreen extends StatefulWidget {
  final HotWheelsCar car;
  const CarDetailScreen({super.key, required this.car});

  @override
  State<CarDetailScreen> createState() => _CarDetailScreenState();
}

class _CarDetailScreenState extends State<CarDetailScreen> {
  final _service = SupabaseService();
  List<HotWheelsCar> _variants = [];
  int _currentImage = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadVariants();
  }

  Future<void> _loadVariants() async {
    final baseName = widget.car.modelName.replaceAll(RegExp(r'\s*\(\d.*\)$'), '').trim();
    try {
      final all = await _service.searchCars(baseName, limit: 20);
      if (mounted) setState(() { _variants = all; _loading = false; });
    } catch (_) {
      if (mounted) setState(() { _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final images = _variants.isNotEmpty
        ? _variants.where((v) => v.imageUrl != null).map((v) => v.imageUrl!).toList()
        : widget.car.imageUrl != null ? [widget.car.imageUrl!] : <String>[];

    return Scaffold(
      appBar: AppBar(title: Text(widget.car.modelName)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image carousel
            if (_loading)
              const AspectRatio(aspectRatio: 16 / 9, child: Center(child: CircularProgressIndicator()))
            else if (images.isNotEmpty) ...[
              AspectRatio(
                aspectRatio: 16 / 9,
                child: PageView.builder(
                  onPageChanged: (i) => setState(() => _currentImage = i),
                  itemCount: images.length,
                  itemBuilder: (ctx, i) => CachedNetworkImage(
                    imageUrl: images[i],
                    fit: BoxFit.contain,
                    placeholder: (_, _) => const Center(child: CircularProgressIndicator()),
                    errorWidget: (_, _, _) => const Icon(Icons.broken_image, color: Colors.white24, size: 60),
                  ),
                ),
              ),
              // Dots indicator
              if (images.length > 1)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(images.length, (i) => Container(
                      width: 6, height: 6,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: i == _currentImage ? HwTheme.orange : Colors.white24,
                      ),
                    )),
                  ),
                ),
            ] else
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(color: HwTheme.surface, child: const Icon(Icons.directions_car, size: 80, color: Colors.white24)),
              ),

            // Variants chips
            if (_variants.length > 1) ...[
              const SizedBox(height: 4),
              SizedBox(
                height: 36,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: _variants.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 6),
                  itemBuilder: (ctx, i) {
                    final v = _variants[i];
                    final isActive = v.toyNum == widget.car.toyNum;
                    return GestureDetector(
                      onTap: () => _switchTo(v),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: isActive ? HwTheme.orange.withValues(alpha: 0.2) : HwTheme.card,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: isActive ? HwTheme.orange : Colors.white12),
                        ),
                        child: Text(
                          v.modelName.contains('(') ? v.modelName.substring(v.modelName.indexOf('(')).replaceAll('(', '').replaceAll(')', '') : '#${v.displayNumber}',
                          style: TextStyle(color: isActive ? HwTheme.orange : Colors.white54, fontSize: 11),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],

            // Details
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.car.modelName, style: Get.textTheme.titleLarge),
                  const SizedBox(height: 4),
                  if (widget.car.series != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: HwTheme.orange.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(6)),
                      child: Text(widget.car.series!, style: const TextStyle(color: HwTheme.orange, fontSize: 13)),
                    ),
                  const SizedBox(height: 20),
                  _detailRow('Year', widget.car.year.toString()),
                  _detailRow('Toy #', widget.car.displayNumber),
                  if (widget.car.seriesNum != null) _detailRow('Series #', widget.car.seriesNum!),
                  if (_variants.length > 1)
                    _detailRow('Variants', '${_variants.length} colors'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _switchTo(HotWheelsCar variant) {
    // Rebuild with selected variant as main
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => CarDetailScreen(car: variant)));
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(width: 100, child: Text(label, style: Get.textTheme.bodyMedium)),
          Expanded(child: Text(value, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }
}
