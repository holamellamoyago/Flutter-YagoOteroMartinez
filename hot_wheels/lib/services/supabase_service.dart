import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/hot_wheels_car.dart';

class SupabaseService {
  final _client = Supabase.instance.client;

  Future<List<int>> getAvailableYears() async {
    final years = <int>{};
    int offset = 0;
    const pageSize = 1000;
    while (true) {
      final data = await _client.from('cars').select('year').order('year', ascending: false).range(offset, offset + pageSize - 1);
      if (data.isEmpty) break;
      for (final row in data) { final y = row['year'] as int?; if (y != null) years.add(y); }
      if (data.length < pageSize) break;
      offset += pageSize;
    }
    return years.toList()..sort((a, b) => b.compareTo(a));
  }

  Future<List<HotWheelsCar>> getCarsByYear(int year, {int limit = 500, int offset = 0}) async {
    final data = await _client.from('cars').select().eq('year', year).order('toy_num').range(offset, offset + limit - 1);
    return data.map<HotWheelsCar>((json) => HotWheelsCar.fromJson(json)).toList();
  }

  // ── Brands ──

  Future<List<String>> getBrands() async => (await _getBrandsWithStats()).map((e) => e.key).toList();

  Future<List<MapEntry<String, _BrandStats>>> _getBrandsWithStats() async {
    final brands = <String, _BrandStats>{};
    int offset = 0; const pageSize = 1000;
    while (true) {
      final data = await _client.from('cars').select('model_name,image_url').range(offset, offset + pageSize - 1);
      if (data.isEmpty) break;
      for (final row in data) {
        final name = (row['model_name'] as String?) ?? '';
        final brand = _extractBrand(name);
        if (brand.isEmpty || RegExp(r"""^['"\d]""").hasMatch(brand)) continue;
        final stats = brands.putIfAbsent(brand, () => _BrandStats());
        stats.count++;
        stats.imageUrl ??= row['image_url'] as String?;
      }
      if (data.length < pageSize) break; offset += pageSize;
    }
    return brands.entries.where((e) => e.value.count >= 2).toList()..sort((a, b) => a.key.compareTo(b.key));
  }

  Future<List<BrandInfo>> getBrandsWithStats() async {
    final entries = await _getBrandsWithStats();
    return entries.map((e) => BrandInfo(name: e.key, count: e.value.count, imageUrl: e.value.imageUrl)).toList();
  }

  String _extractBrand(String modelName) {
    final cleaned = modelName.trim();
    if (cleaned.isEmpty) return '';
    if (RegExp(r"^'\d").hasMatch(cleaned)) {
      final words = cleaned.split(' '); if (words.length >= 2) return _extractBrand(words.sublist(1).join(' ')); return '';
    }
    final firstWord = cleaned.split(' ').first;
    if (RegExp(r'^\d+$').hasMatch(firstWord)) {
      final words = cleaned.split(' '); if (words.length >= 2) return _extractBrand(words.sublist(1).join(' ')); return '';
    }
    if (cleaned.startsWith('Land Rover')) return 'Land Rover';
    if (cleaned.startsWith('Aston Martin')) return 'Aston Martin';
    if (cleaned.startsWith('Mercedes-Benz') || cleaned.startsWith('Mercedes Benz')) return 'Mercedes-Benz';
    if (cleaned.startsWith('Alfa Romeo')) return 'Alfa Romeo';
    return firstWord;
  }

  // ── Series ──

  Future<List<String>> getSeries() async {
    final series = <String, int>{};
    int offset = 0; const pageSize = 1000;
    while (true) {
      final data = await _client.from('cars').select('series').not('series', 'is', null).range(offset, offset + pageSize - 1);
      if (data.isEmpty) break;
      for (final row in data) {
        final s = (row['series'] as String?) ?? '';
        if (s.isNotEmpty && !RegExp(r"^'\d").hasMatch(s)) series[s] = (series[s] ?? 0) + 1;
      }
      if (data.length < pageSize) break; offset += pageSize;
    }
    return series.entries.where((e) => e.value >= 3).map((e) => e.key).toList()..sort();
  }

  Future<List<SeriesInfo>> getSeriesWithStats() async {
    final series = <String, _SeriesStats>{};
    int offset = 0; const pageSize = 1000;
    while (true) {
      final data = await _client.from('cars').select('series,image_url').not('series', 'is', null).range(offset, offset + pageSize - 1);
      if (data.isEmpty) break;
      for (final row in data) {
        final s = (row['series'] as String?) ?? '';
        if (s.isEmpty || RegExp(r"^'\d").hasMatch(s)) continue;
        final stats = series.putIfAbsent(s, () => _SeriesStats());
        stats.count++;
        stats.imageUrl ??= row['image_url'] as String?;
      }
      if (data.length < pageSize) break; offset += pageSize;
    }
    return series.entries.where((e) => e.value.count >= 3).map((e) => SeriesInfo(name: e.key, count: e.value.count, imageUrl: e.value.imageUrl)).toList()..sort((a, b) => a.name.compareTo(b.name));
  }

  // ── Filtered search ──

  Future<List<HotWheelsCar>> searchByFilters({String? query, String? brand, String? series, int? year, int limit = 200}) async {
    var q = _client.from('cars').select();
    if (query != null && query.trim().isNotEmpty) q = q.ilike('model_name', '%${query.trim()}%');
    if (brand != null && brand.isNotEmpty) q = q.ilike('model_name', '$brand%');
    if (series != null && series.isNotEmpty) q = q.ilike('series', '%$series%');
    if (year != null) q = q.eq('year', year);
    final data = await q.order('model_name').limit(limit);
    return data.map<HotWheelsCar>((json) => HotWheelsCar.fromJson(json)).toList();
  }

  Future<List<HotWheelsCar>> searchCars(String query, {int limit = 50}) async => searchByFilters(query: query, limit: limit);
}

class _BrandStats { int count = 0; String? imageUrl; }
class _SeriesStats { int count = 0; String? imageUrl; }
class BrandInfo { final String name; final int count; final String? imageUrl; BrandInfo({required this.name, required this.count, this.imageUrl}); }
class SeriesInfo { final String name; final int count; final String? imageUrl; SeriesInfo({required this.name, required this.count, this.imageUrl}); }
