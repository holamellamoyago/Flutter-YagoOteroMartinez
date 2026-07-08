import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/auth_controller.dart';
import '../models/hot_wheels_car.dart';
import '../services/supabase_service.dart';
import '../theme/hw_theme.dart';
import 'car_detail_screen.dart';
import 'login_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final _service = SupabaseService();
  List<HotWheelsCar> _cars = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (!AuthController.to.isLoggedIn.value) {
      setState(() => _loading = false);
      return;
    }
    setState(() => _loading = true);
    try {
      _cars = await _service.getFavorites();
    } catch (_) {}
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final auth = AuthController.to;

    if (!auth.isLoggedIn.value) {
      return Scaffold(
        appBar: AppBar(title: const Text('Favorites')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.favorite_outline,
                  size: 64, color: HwTheme.orange.withAlpha(80)),
              const SizedBox(height: 16),
              const Text('Sign in to save favorites'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Get.to(() => const LoginScreen()),
                child: const Text('Sign In'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _cars.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.favorite_outline,
                          size: 64, color: HwTheme.orange.withAlpha(80)),
                      const SizedBox(height: 16),
                      const Text('No favorites yet'),
                      const SizedBox(height: 8),
                      Text('Tap ♡ on any car to add it here',
                          style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _load,
                  color: HwTheme.orange,
                  child: GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 0.72,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: _cars.length,
                    itemBuilder: (ctx, i) {
                      final car = _cars[i];
                      return GestureDetector(
                        onTap: () =>
                            Get.to(() => CarDetailScreen(car: car)),
                        child: Card(
                          child: Column(
                            children: [
                              Expanded(
                                child: car.imageUrl != null
                                    ? ClipRRect(
                                        borderRadius:
                                            const BorderRadius.vertical(
                                                top: Radius.circular(12)),
                                        child: CachedNetworkImage(
                                          imageUrl: car.imageUrl!,
                                          fit: BoxFit.contain,
                                          width: double.infinity,
                                        ),
                                      )
                                    : const Icon(Icons.directions_car,
                                        size: 40, color: Colors.white24),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(6),
                                child: Text(
                                  car.modelName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 11),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
