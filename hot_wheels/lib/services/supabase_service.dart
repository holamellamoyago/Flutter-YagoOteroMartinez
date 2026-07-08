import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/hot_wheels_car.dart';

class SupabaseService {
  final _client = Supabase.instance.client;

  // ── Years ──

  Future<List<int>> getAvailableYears() async {
    final data = await _client
        .from('cars')
        .select('year')
        .order('year', ascending: false);
    final years = <int>{};
    for (final row in data) {
      years.add(row['year'] as int);
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

  // ── Brands ──

  Future<List<String>> getBrands() async {
    final data = await _client.from('cars').select('model_name');
    final brands = <String>{};
    for (final row in data) {
      final name = (row['model_name'] as String?) ?? '';
      final brand = _extractBrand(name);
      if (brand.isNotEmpty) brands.add(brand);
    }
    final sorted = brands.toList()..sort();
    return sorted;
  }

  String _extractBrand(String modelName) {
    // Common prefixes that aren't real brands
    const nonBrands = {
      "'", 'HW', 'Hot', 'Fast', 'Super', 'Custom', 'Street', 'Race',
      'Track', 'Speed', 'Muscle', 'Classic', 'Twin', 'Rodger', 'Total',
      'Volkswagen',  // special case: keep full "Volkswagen"
    };
    final words = modelName.trim().split(' ');
    if (words.isEmpty) return '';
    final first = words.first;
    // Keep compound brand names
    if (first == 'Land' && words.length > 1 && words[1] == 'Rover') return 'Land Rover';
    if (first == 'Aston' && words.length > 1 && words[1] == 'Martin') return 'Aston Martin';
    if (first == 'Mercedes-Benz' || (first == 'Mercedes' && words.length > 1 && words[1] == 'Benz')) return 'Mercedes-Benz';
    if (nonBrands.contains(first)) return '';
    return first;
  }

  // ── Series ──

  Future<List<String>> getSeries() async {
    final data = await _client
        .from('cars')
        .select('series')
        .not('series', 'is', null)
        .order('series');
    final series = <String>{};
    for (final row in data) {
      final s = (row['series'] as String?) ?? '';
      if (s.isNotEmpty) series.add(s);
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
}
