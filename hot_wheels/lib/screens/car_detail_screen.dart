import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/lists_controller.dart';
import '../models/hot_wheels_car.dart';
import '../services/supabase_service.dart';
import '../theme/hw_theme.dart';
import 'login_screen.dart';

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
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _loadVariants();
    _checkFavorite();
    _recordView();
  }

  Future<void> _loadVariants() async {
    final baseName = widget.car.modelName
        .replaceAll(RegExp(r'\s*\(\d.*\)$'), '')
        .trim();
    try {
      final all = await _service.searchCars(baseName, limit: 20);
      if (mounted) setState(() { _variants = all; _loading = false; });
    } catch (_) {
      if (mounted) setState(() { _loading = false; });
    }
  }

  Future<void> _checkFavorite() async {
    try {
      final fav = await _service.isFavorite(widget.car);
      if (mounted) setState(() => _isFavorite = fav);
    } catch (_) {}
  }

  Future<void> _recordView() async {
    await _service.recordView(widget.car);
  }

  Future<void> _toggleFavorite() async {
    if (!AuthController.to.isLoggedIn.value) {
      _showAuthGate('favorite cars', 'build your dream garage wishlist');
      return;
    }
    await _service.toggleFavorite(widget.car);
    setState(() => _isFavorite = !_isFavorite);
  }

  void _showAuthGate(String feature, String benefit) {
    Get.dialog(
      AlertDialog(
        backgroundColor: Theme.of(context).cardTheme.color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        icon: Icon(Icons.lock_outline, color: Theme.of(context).colorScheme.primary, size: 48),
        title: Text('Sign in to $feature'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(benefit, style: TextStyle(color: Theme.of(context).textTheme.bodyMedium!.color!)),
            const SizedBox(height: 12),
            _benefitRow(Icons.bookmark, 'Save cars to custom lists'),
            _benefitRow(Icons.share, 'Share collections with friends'),
            _benefitRow(Icons.favorite, 'Favorite your dream cars'),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Get.back(),
              child: const Text('Later')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.to(() => const LoginScreen());
            },
            child: const Text('Sign in'),
          ),
        ],
      ),
    );
  }

  Widget _benefitRow(IconData icon, String text) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary, size: 18),
            const SizedBox(width: 8),
            Expanded(
                child: Text(text,
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium!.color!, fontSize: 13))),
          ],
        ),
      );

  void _showAddToList() {
    if (!AuthController.to.isLoggedIn.value) {
      _showAuthGate('save cars to lists', 'create collections and share with friends');
      return;
    }

    final lists = ListsController.to.lists;

    Get.bottomSheet(
      Container(
        constraints: BoxConstraints(maxHeight: Get.height * 0.6),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                  color: Theme.of(context).textTheme.bodySmall!.color!,
                  borderRadius: BorderRadius.circular(2)),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Text('Add to list',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () {
                      Get.back();
                      _showCreateAndAdd();
                    },
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('New list'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                if (lists.isEmpty) {
                  return Center(
                    child: Text('No lists yet — create one!',
                        style: TextStyle(color: Theme.of(context).textTheme.bodySmall!.color!)),
                  );
                }
                return ListView.builder(
                  itemCount: lists.length,
                  itemBuilder: (ctx, i) {
                    final list = lists[i];
                    return FutureBuilder<bool>(
                      future: _service.isCarInList(list.id, widget.car),
                      builder: (ctx, snap) {
                        final isInList = snap.data ?? false;
                        return ListTile(
                          leading: Icon(
                            isInList
                                ? Icons.check_circle
                                : Icons.circle_outlined,
                            color: isInList ? Theme.of(context).colorScheme.primary : Theme.of(context).textTheme.bodySmall!.color!,
                          ),
                          title: Text(list.name),
                          subtitle: Text('${list.carCount} cars',
                              style: Theme.of(context).textTheme.bodySmall),
                          onTap: () async {
                            if (isInList) {
                              await _service.removeCarFromList(
                                  list.id,
                                  widget.car.toyNum ?? '',
                                  widget.car.modelName,
                                  widget.car.year);
                            } else {
                              await _service.addCarToList(list.id, widget.car);
                            }
                            ListsController.to.load();
                            Get.back();
                            Get.snackbar(
                              isInList ? 'Removed' : 'Added',
                              isInList
                                  ? 'Removed from "${list.name}"'
                                  : 'Added to "${list.name}"',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: const Color(0xFF1B5E20),
                              colorText: const Color(0xFFFFFFFF),
                            );
                          },
                        );
                      },
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateAndAdd() {
    final nameCtrl = TextEditingController();
    Get.dialog(
      AlertDialog(
        backgroundColor: Theme.of(context).cardTheme.color,
        title: const Text('New List'),
        content: TextField(
          controller: nameCtrl,
          decoration: const InputDecoration(
            labelText: 'List name',
            hintText: 'e.g. Dream Garage',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (nameCtrl.text.trim().isEmpty) return;
              try {
                final list = await _service.createList(nameCtrl.text.trim());
                await _service.addCarToList(list.id, widget.car);
                ListsController.to.load();
                Get.back();
                Get.snackbar('Added', 'Added to "${list.name}"',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: const Color(0xFF1B5E20),
                    colorText: const Color(0xFFFFFFFF));
              } catch (e) {
                Get.snackbar('Error', e.toString(),
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: const Color(0xFFB71C1C),
                    colorText: const Color(0xFFFFFFFF));
              }
            },
            child: const Text('Create & Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final images = _variants.isNotEmpty
        ? _variants
            .where((v) => v.imageUrl != null)
            .map((v) => v.imageUrl!)
            .toList()
        : widget.car.imageUrl != null
            ? [widget.car.imageUrl!]
            : <String>[];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.car.modelName),
        actions: [
          // Favorite button
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? Colors.red : null,
            ),
            onPressed: _toggleFavorite,
          ),
          // Add to list button
          IconButton(
            icon: const Icon(Icons.playlist_add),
            onPressed: _showAddToList,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image carousel
            if (_loading)
              const AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Center(child: CircularProgressIndicator()))
            else if (images.isNotEmpty) ...[
              AspectRatio(
                aspectRatio: 16 / 9,
                child: PageView.builder(
                  onPageChanged: (i) =>
                      setState(() => _currentImage = i),
                  itemCount: images.length,
                  itemBuilder: (ctx, i) => CachedNetworkImage(
                    imageUrl: images[i],
                    fit: BoxFit.contain,
                    placeholder: (_, __) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (_, __, ___) =>
                        Icon(Icons.broken_image,
                            color: Theme.of(context).textTheme.bodySmall!.color!, size: 60),
                  ),
                ),
              ),
              if (images.length > 1)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      images.length,
                      (i) => Container(
                        width: 6,
                        height: 6,
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: i == _currentImage
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).textTheme.bodySmall!.color!,
                        ),
                      ),
                    ),
                  ),
                ),
            ] else
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  color: Theme.of(context).cardTheme.color,
                  child: Icon(Icons.directions_car,
                      size: 80, color: Theme.of(context).textTheme.bodySmall!.color!),
                ),
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
                  separatorBuilder: (_, __) => const SizedBox(width: 6),
                  itemBuilder: (ctx, i) {
                    final v = _variants[i];
                    final isActive = v.toyNum == widget.car.toyNum;
                    return GestureDetector(
                      onTap: () => _switchTo(v),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: isActive
                              ? Theme.of(context).colorScheme.primary.withAlpha(50)
                              : Theme.of(context).cardTheme.color,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color: isActive
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).dividerColor),
                        ),
                        child: Text(
                          v.modelName.contains('(')
                              ? v.modelName
                                  .substring(v.modelName.indexOf('('))
                                  .replaceAll('(', '')
                                  .replaceAll(')', '')
                              : '#${v.displayNumber}',
                          style: TextStyle(
                            color: isActive
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).textTheme.bodySmall!.color!,
                            fontSize: 11,
                          ),
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
                  Text(widget.car.modelName,
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 4),
                  if (widget.car.series != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: HwTheme.orange.withAlpha(40),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(widget.car.series!,
                          style: const TextStyle(
                              color: HwTheme.orange, fontSize: 13)),
                    ),
                  const SizedBox(height: 20),
                  _detailRow('Year', widget.car.year.toString()),
                  _detailRow('Toy #', widget.car.displayNumber),
                  if (widget.car.seriesNum != null)
                    _detailRow('Series #', widget.car.seriesNum!),
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
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (_) => CarDetailScreen(car: variant)),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(label,
                style: Theme.of(context).textTheme.bodyMedium),
          ),
          Expanded(
            child: Text(value,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                )),
          ),
        ],
      ),
    );
  }
}
