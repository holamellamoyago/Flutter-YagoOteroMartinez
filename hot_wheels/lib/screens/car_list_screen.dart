import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import '../controllers/app_controllers.dart';
import '../theme/hw_theme.dart';
import 'car_detail_screen.dart';

class CarListScreen extends StatelessWidget {
  final int year;
  const CarListScreen({super.key, required this.year});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(CarsController(year));
    return Scaffold(
      appBar: AppBar(title: Text(year.toString())),
      body: Obx(() {
        if (c.loading.value) return const Center(child: CircularProgressIndicator());
        if (c.cars.isEmpty) return Center(child: Text('No cars found', style: Get.textTheme.bodyMedium));
        return _buildGrid(_groupByModel(c.cars));
      }),
    );
  }

  /// Group variants of the same car (e.g. "Zotic", "Zotic (2nd Color)")
  List<_CarGroup> _groupByModel(List cars) {
    final map = <String, _CarGroup>{};
    for (final car in cars) {
      final base = car.modelName.replaceAll(RegExp(r'\s*\(\d.*\)$'), '').trim();
      if (map.containsKey(base)) {
        map[base]!.variants.add(car);
        if (car.imageUrl != null) map[base]!.images.add(car.imageUrl!);
      } else {
        final group = _CarGroup(primary: car, variants: [car], images: []);
        if (car.imageUrl != null) group.images.add(car.imageUrl!);
        map[base] = group;
      }
    }
    return map.values.toList()..sort((a, b) => a.primary.modelName.compareTo(b.primary.modelName));
  }

  Widget _buildGrid(List<_CarGroup> groups) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.75,
      ),
      itemCount: groups.length,
      itemBuilder: (ctx, i) => _CarCard(group: groups[i]),
    );
  }
}

class _CarGroup {
  final dynamic primary;
  final List<dynamic> variants;
  final List<String> images;
  _CarGroup({required this.primary, required this.variants, required this.images});
}

class _CarCard extends StatefulWidget {
  final _CarGroup group;
  const _CarCard({required this.group});

  @override
  State<_CarCard> createState() => _CarCardState();
}

class _CarCardState extends State<_CarCard> with SingleTickerProviderStateMixin {
  late final AnimationController _anim;
  final _pageController = PageController();
  int _current = 0;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(vsync: this, duration: const Duration(seconds: 4));
    if (widget.group.images.length > 1) {
      _anim.addStatusListener((s) {
        if (s == AnimationStatus.completed && mounted) {
          final next = (_current + 1) % widget.group.images.length;
          _pageController.animateToPage(next, duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
        }
      });
      _anim.forward();
    }
  }

  @override
  void dispose() {
    _anim.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final car = widget.group.primary;
    final images = widget.group.images;
    final hasVariants = widget.group.variants.length > 1;

    return GestureDetector(
      onTap: () => Get.to(() => CarDetailScreen(car: car)),
      child: Container(
        decoration: BoxDecoration(
          color: HwTheme.card,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image stack
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(9)),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (images.isEmpty)
                      const Icon(Icons.directions_car, color: Colors.white24, size: 32)
                    else if (images.length == 1)
                      CachedNetworkImage(imageUrl: images.first, fit: BoxFit.cover, placeholder: (_, _) => const Center(child: Icon(Icons.directions_car, color: Colors.white24, size: 32)), errorWidget: (_, _, _) => const Icon(Icons.broken_image, color: Colors.white24))
                    else
                      PageView.builder(
                        controller: _pageController,
                        onPageChanged: (i) {
                          setState(() => _current = i);
                          _anim.forward(from: 0);
                        },
                        itemCount: images.length,
                        itemBuilder: (ctx, i) => CachedNetworkImage(imageUrl: images[i], fit: BoxFit.cover, placeholder: (_, _) => const Center(child: Icon(Icons.directions_car, color: Colors.white24, size: 32)), errorWidget: (_, _, _) => const Icon(Icons.broken_image, color: Colors.white24)),
                      ),
                    // Variant badge
                    if (hasVariants)
                      Positioned(
                        top: 4, right: 4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                          decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(6)),
                          child: Text('${widget.group.variants.length}', style: const TextStyle(color: HwTheme.orange, fontSize: 9, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    // Page dots
                    if (images.length > 1)
                      Positioned(
                        bottom: 2, left: 0, right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(images.length, (i) => Container(
                            width: 4, height: 4,
                            margin: const EdgeInsets.symmetric(horizontal: 1.5),
                            decoration: BoxDecoration(shape: BoxShape.circle, color: i == _current ? HwTheme.orange : Colors.white38),
                          )),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            // Info
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(car.modelName, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w500)),
                    if (car.series != null)
                      Text(car.series!, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 8, color: HwTheme.orange)),
                    const Spacer(),
                    Text('#${car.displayNumber}', style: const TextStyle(fontSize: 9, color: Colors.white38)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
