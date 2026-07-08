import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/hot_wheels_car.dart';

class SupabaseService {
  final _client = Supabase.instance.client;

  // ── Years (paginated to get all distinct) ──

  Future<List<int>> getAvailableYears() async {
    final years = <int>{};
    int offset = 0;
    const pageSize = 1000;

    while (true) {
      final data = await _client
          .from('cars')
          .select('year')
          .order('year', ascending: false)
          .range(offset, offset + pageSize - 1);
      if (data.isEmpty) break;
      for (final row in data) {
        final y = row['year'] as int?;
        if (y != null) years.add(y);
      }
      if (data.length < pageSize) break;
      offset += pageSize;
    }

    return years.toList()..sort((a, b) => b.compareTo(a));
  }

  // ── Cars by year ──

  Future<List<HotWheelsCar>> getCarsByYear(int year, {int limit = 500, int offset = 0}) async {
    final data = await _client
        .from('cars')
        .select()
        .eq('year', year)
        .order('toy_num')
        .range(offset, offset + limit - 1);
    return data.map<HotWheelsCar>((json) => HotWheelsCar.fromJson(json)).toList();
  }

  // ── Brands (extracted from model_name, paginated) ──

  Future<List<String>> getBrands() async {
    final brands = <String>{};
    int offset = 0;
    const pageSize = 1000;

    while (true) {
      final data = await _client
          .from('cars')
          .select('model_name')
          .range(offset, offset + pageSize - 1);
      if (data.isEmpty) break;
      for (final row in data) {
        final name = (row['model_name'] as String?) ?? '';
        final brand = _extractBrand(name);
        if (brand.isNotEmpty) brands.add(brand);
      }
      if (data.length < pageSize) break;
      offset += pageSize;
    }

    final sorted = brands.toList()..sort();
    return sorted;
  }

  String _extractBrand(String modelName) {
    final cleaned = modelName.trim();
    if (cleaned.isEmpty) return '';

    // Skip if starts with apostrophe + digits (e.g. '58, '07)
    if (RegExp(r"^'\d").hasMatch(cleaned)) {
      // Try second word as brand
      final words = cleaned.split(' ');
      if (words.length >= 2) return _extractBrand(words.sublist(1).join(' '));
      return '';
    }

    // Skip if first token is purely numeric or year-like
    final firstWord = cleaned.split(' ').first;
    if (RegExp(r'^\d+$').hasMatch(firstWord)) {
      final words = cleaned.split(' ');
      if (words.length >= 2) return _extractBrand(words.sublist(1).join(' '));
      return '';
    }

    // Known multi-word brands
    if (cleaned.startsWith('Land Rover')) return 'Land Rover';
    if (cleaned.startsWith('Aston Martin')) return 'Aston Martin';
    if (cleaned.startsWith('Mercedes-Benz') || cleaned.startsWith('Mercedes Benz')) return 'Mercedes-Benz';
    if (cleaned.startsWith('Alfa Romeo')) return 'Alfa Romeo';

    return firstWord;
  }

  // ── Series (paginated) ──

  Future<List<String>> getSeries() async {
    final series = <String>{};
    int offset = 0;
    const pageSize = 1000;

    while (true) {
      final data = await _client
          .from('cars')
          .select('series')
          .not('series', 'is', null)
          .range(offset, offset + pageSize - 1);
      if (data.isEmpty) break;
      for (final row in data) {
        final s = (row['series'] as String?) ?? '';
        if (s.isNotEmpty) series.add(s);
      }
      if (data.length < pageSize) break;
      offset += pageSize;
    }

    return series.toList()..sort();
  }

  // ── Filtered search ──

  Future<List<HotWheelsCar>> searchByFilters({
    String? query,
    String? brand,
    String? series,
    int? year,
    int limit = 200,
  }) async {
    var q = _client.from('cars').select();

    if (query != null && query.trim().isNotEmpty) {
      q = q.ilike('model_name', '%${query.trim()}%');
    }
    if (brand != null && brand.isNotEmpty) {
      q = q.ilike('model_name', '$brand%');
    }
    if (series != null && series.isNotEmpty) {
      q = q.ilike('series', '%$series%');
    }
    if (year != null) {
      q = q.eq('year', year);
    }

    final data = await q.order('model_name').limit(limit);
    return data.map<HotWheelsCar>((json) => HotWheelsCar.fromJson(json)).toList();
  }

  // ── Simple search ──

  Future<List<HotWheelsCar>> searchCars(String query, {int limit = 50}) async {
    return searchByFilters(query: query, limit: limit);
  }

  // ── Coches recientes (para pantalla principal) ──

  Future<List<HotWheelsCar>> getLatestCars({int limit = 50}) async {
    final data = await _client
        .from('cars')
        .select()
        .order('created_at', ascending: false)
        .limit(limit);
    return data.map<HotWheelsCar>((json) => HotWheelsCar.fromJson(json)).toList();
  }
}
