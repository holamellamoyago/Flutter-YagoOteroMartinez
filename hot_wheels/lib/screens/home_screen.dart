import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/app_controllers.dart';
import '../controllers/auth_controller.dart';
import '../controllers/filter_controller.dart';
import '../models/hot_wheels_car.dart';
import '../services/supabase_service.dart';
import '../theme/hw_theme.dart';
import 'car_list_screen.dart';
import 'car_detail_screen.dart';
import 'filter_screen.dart';
import 'brand_list_screen.dart';
import 'series_list_screen.dart';
import 'login_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends GetView<YearsController> {
  const HomeScreen({super.key});

  FilterController get _filter => Get.find<FilterController>();
  AuthController get _auth => Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    Get.put(YearsController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hot Wheels'),
        actions: [
          Obx(() {
            final user = _auth.user.value;
            if (user != null) {
              final avatar = user.userMetadata?['avatar_url'] as String?;
              return IconButton(
                icon: CircleAvatar(
                  radius: 14,
                  child: Text(
                      (user.userMetadata?['full_name']?.toString() ??
                              user.email ??
                              'U')[0]
                          .toUpperCase(),
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: HwTheme.orange)),
                  foregroundImage: avatar != null ? NetworkImage(avatar) : null,
                ),
                tooltip: 'Account',
                onPressed: () => Get.to(() => const ProfileScreen()),
              );
            }
            return IconButton(
              icon: const Icon(Icons.person_outline),
              tooltip: 'Sign in',
              onPressed: () => Get.to(() => const LoginScreen()),
            );
          }),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => Get.to(() => const FilterScreen()),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.loading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.error.value != null) return _buildError();
        return _buildSections(context);
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
        ElevatedButton(
            onPressed: () => controller.load(), child: const Text('Retry')),
      ]),
    );
  }

  Widget _buildSections(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(top: 8, bottom: 80),
      children: [
        // ── Car of the Day ──
        const SizedBox(height: 8),
        const _DailyCarCard(),
        const SizedBox(height: 24),

        // ── Create promo ──
        _CreatePromo(context),
        const SizedBox(height: 24),

        // ── By Year ──
        _SectionHeader(
            title: 'By Year',
            subtitle: '${controller.years.length} years',
            onSeeAll: () {}),
        _YearRow(years: controller.years),
        const SizedBox(height: 24),

        // ── By Brand ──
        _SectionHeader(
            title: 'By Brand',
            subtitle: '${_filter.brands.length} brands',
            onSeeAll: () => Get.to(() => const BrandListScreen())),
        _BrandRow(
            brands: _filter.brands, onTap: (b) => _openFilter(brand: b)),
        const SizedBox(height: 24),

        // ── By Series ──
        _SectionHeader(
            title: 'By Series',
            subtitle: '${_filter.series.length} series',
            onSeeAll: () => Get.to(() => const SeriesListScreen())),
        _SeriesRow(
            series: _filter.series, onTap: (s) => _openFilter(series: s)),
      ],
    );
  }

  void _openFilter({String? brand, String? series}) {
    if (brand != null) {
      _filter.selectedBrand.value = brand;
      _filter.search();
    }
    if (series != null) {
      _filter.selectedSeries.value = series;
      _filter.search();
    }
    Get.to(() => const FilterScreen());
  }
}

// ── Car of the Day ──

class _DailyCarCard extends StatefulWidget {
  const _DailyCarCard();

  @override
  State<_DailyCarCard> createState() => _DailyCarCardState();
}

class _DailyCarCardState extends State<_DailyCarCard> {
  final _service = SupabaseService();
  HotWheelsCar? _car;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final car = await _service.getDailyCar();
      if (mounted) setState(() { _car = car; _loading = false; });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: _car != null
            ? () => Get.to(() => CarDetailScreen(car: _car!))
            : null,
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [HwTheme.orange, HwTheme.flame],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(16),
          child: _loading
              ? const SizedBox(
                  height: 100,
                  child: Center(
                      child: CircularProgressIndicator(color: Colors.white)))
              : _car == null
                  ? const SizedBox(
                      height: 100,
                      child: Center(
                          child: Text('No cars available',
                              style: TextStyle(color: Colors.white70))))
                  : Row(
                      children: [
                        // Car image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: _car!.imageUrl != null
                              ? CachedNetworkImage(
                                  imageUrl: _car!.imageUrl!,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.contain,
                                )
                              : Container(
                                  width: 100,
                                  height: 100,
                                  color: Colors.black26,
                                  child: const Icon(Icons.directions_car,
                                      size: 48, color: Colors.white38),
                                ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.black26,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.local_fire_department,
                                        color: Colors.amber, size: 14),
                                    SizedBox(width: 4),
                                    Text('Car of the Day',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(_car!.modelName,
                                  style: TextStyle(
                                      color: cs.onPrimary,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis),
                              const SizedBox(height: 4),
                              Text(
                                  '${_car!.year}${_car!.series != null ? ' · ${_car!.series}' : ''}',
                                  style: TextStyle(
                                      color: cs.onPrimary.withAlpha(180),
                                      fontSize: 13)),
                            ],
                          ),
                        ),
                        Icon(Icons.chevron_right,
                            color: cs.onPrimary.withAlpha(120)),
                      ],
                    ),
        ),
      ),
    );
  }
}

// ── Create promo card ──

Widget _CreatePromo(BuildContext context) {
  final cs = Theme.of(context).colorScheme;
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: GestureDetector(
      onTap: () {
        // Switch to Create tab — we use HomeScreen's parent callback
        // For now, just show a snackbar hint
      },
      child: Container(
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cs.primary.withAlpha(40)),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [HwTheme.orange, HwTheme.flame],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.auto_awesome,
                  color: Colors.white, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Create your own Hot Wheel',
                      style: TextStyle(
                          color: cs.onSurface,
                          fontWeight: FontWeight.w600,
                          fontSize: 14)),
                  const SizedBox(height: 2),
                  Text('Upload a photo, AI generates your design',
                      style: TextStyle(
                          color: cs.onSurface.withAlpha(150),
                          fontSize: 12)),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: cs.onSurface.withAlpha(80)),
          ],
        ),
      ),
    ),
  );
}

// ── Section header ──

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onSeeAll;
  const _SectionHeader(
      {required this.title, required this.subtitle, required this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Text(title,
              style: TextStyle(
                  color: cs.onSurface,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
                color: cs.primary.withAlpha(30),
                borderRadius: BorderRadius.circular(10)),
            child: Text(subtitle,
                style: TextStyle(color: cs.primary, fontSize: 11)),
          ),
          const Spacer(),
          GestureDetector(
              onTap: onSeeAll,
              child: Text('See all',
                  style: TextStyle(color: cs.primary, fontSize: 13))),
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
    final cs = Theme.of(context).colorScheme;
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
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [HwTheme.orange, HwTheme.flame],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight),
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              alignment: Alignment.center,
              child: Text(y.toString(),
                  style: TextStyle(
                      color: cs.onPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
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
    final theme = Theme.of(context);
    final text = theme.textTheme;
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
              decoration: BoxDecoration(
                  color: theme.cardTheme.color ?? theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: theme.dividerColor)),
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(b,
                  style: TextStyle(
                      color: text.bodyMedium!.color!,
                      fontSize: 13,
                      fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis),
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
    final theme = Theme.of(context);
    final text = theme.textTheme;
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
              decoration: BoxDecoration(
                  color: theme.cardTheme.color ?? theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: theme.dividerColor)),
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(s,
                  style: TextStyle(
                      color: text.bodyMedium!.color!, fontSize: 11),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
            ),
          );
        },
      ),
    );
  }
}
