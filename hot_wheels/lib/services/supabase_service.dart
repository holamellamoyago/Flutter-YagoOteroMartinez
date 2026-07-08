import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/hot_wheels_car.dart';
import '../models/user_list.dart';

class SupabaseService {
  final _client = Supabase.instance.client;

  // ──────────────────────────────────────────────
  // Cars (existing)
  // ──────────────────────────────────────────────

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
    return brands.entries.where((e) => e.value.count >= 2).toList()
      ..sort((a, b) => b.value.count.compareTo(a.value.count));
  }

  Future<List<BrandInfo>> getBrandsWithStats() async {
    final entries = await _getBrandsWithStats();
    return entries.map((e) => BrandInfo(name: e.key, count: e.value.count, imageUrl: e.value.imageUrl)).toList()
      ..sort((a, b) => b.count.compareTo(a.count));
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
    return series.entries.where((e) => e.value >= 3).map((e) => e.key).toList()
      ..sort((a, b) {
        final aNum = RegExp(r'^\d').hasMatch(a);
        final bNum = RegExp(r'^\d').hasMatch(b);
        if (aNum && !bNum) return 1;
        if (!aNum && bNum) return -1;
        return a.compareTo(b);
      });
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
    return series.entries.where((e) => e.value.count >= 3).map((e) => SeriesInfo(name: e.key, count: e.value.count, imageUrl: e.value.imageUrl)).toList()
      ..sort((a, b) {
        final aNum = RegExp(r'^\d').hasMatch(a.name);
        final bNum = RegExp(r'^\d').hasMatch(b.name);
        if (aNum && !bNum) return 1;
        if (!aNum && bNum) return -1;
        return b.count.compareTo(a.count);
      });
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

  // ──────────────────────────────────────────────
  // User Lists
  // ──────────────────────────────────────────────

  Future<List<UserList>> getUserLists() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return [];
    final data = await _client
        .from('lists')
        .select('*, list_cars!inner(car_image_url)')
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return data.map<UserList>((json) {
      // Count cars via the join
      final cars = (json['list_cars'] as List?) ?? [];
      final preview = cars.isNotEmpty ? (cars.first as Map)['car_image_url'] as String? : null;
      return UserList(
        id: json['id'] as String,
        userId: json['user_id'] as String,
        name: json['name'] as String,
        description: json['description'] as String?,
        isPublic: json['is_public'] as bool? ?? false,
        carCount: cars.length,
        previewImage: preview,
        createdAt: DateTime.parse(json['created_at'] as String),
      );
    }).toList();
  }

  Future<UserList> createList(String name, {String? description, bool isPublic = false}) async {
    final userId = _client.auth.currentUser!.id;
    final data = await _client.from('lists').insert({
      'user_id': userId,
      'name': name,
      'description': description,
      'is_public': isPublic,
    }).select().single();
    return UserList.fromJson(data);
  }

  Future<void> updateList(String listId, {String? name, String? description, bool? isPublic}) async {
    final updates = <String, dynamic>{};
    if (name != null) updates['name'] = name;
    if (description != null) updates['description'] = description;
    if (isPublic != null) updates['is_public'] = isPublic;
    if (updates.isNotEmpty) {
      updates['updated_at'] = DateTime.now().toIso8601String();
      await _client.from('lists').update(updates).eq('id', listId);
    }
  }

  Future<void> deleteList(String listId) async {
    await _client.from('lists').delete().eq('id', listId);
  }

  Future<void> addCarToList(String listId, HotWheelsCar car) async {
    await _client.from('list_cars').insert({
      'list_id': listId,
      'car_year': car.year,
      'car_toy_num': car.toyNum ?? '',
      'car_model_name': car.modelName,
      'car_image_url': car.imageUrl,
      'car_series': car.series,
    });
  }

  Future<void> removeCarFromList(String listId, String carToyNum, String carModelName, int carYear) async {
    await _client.from('list_cars').delete().eq('list_id', listId).eq('car_toy_num', carToyNum).eq('car_model_name', carModelName).eq('car_year', carYear);
  }

  Future<List<ListCarEntry>> getListCars(String listId) async {
    final data = await _client.from('list_cars').select().eq('list_id', listId).order('added_at', ascending: false);
    return data.map<ListCarEntry>((json) => ListCarEntry.fromJson(json)).toList();
  }

  Future<UserList?> getPublicList(String listId) async {
    final data = await _client.from('lists').select().eq('id', listId).eq('is_public', true).maybeSingle();
    if (data == null) return null;
    return UserList.fromJson(data);
  }

  Future<bool> isCarInList(String listId, HotWheelsCar car) async {
    final data = await _client
        .from('list_cars')
        .select('list_id')
        .eq('list_id', listId)
        .eq('car_toy_num', car.toyNum ?? '')
        .eq('car_model_name', car.modelName)
        .eq('car_year', car.year)
        .limit(1);
    return (data as List).isNotEmpty;
  }

  Future<int> getCarCount() async {
    final _ = await _client.from('cars').select('id').limit(1);
    return 0; // Placeholder — paginate for exact count
  }

  // ──────────────────────────────────────────────
  // Favorites
  // ──────────────────────────────────────────────

  Future<void> toggleFavorite(HotWheelsCar car) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return;
    final exists = await _isFavorite(car);
    if (exists) {
      await _client.from('favorites').delete().eq('user_id', userId).eq('car_year', car.year).eq('car_toy_num', car.toyNum ?? '').eq('car_model_name', car.modelName);
    } else {
      await _client.from('favorites').insert({
        'user_id': userId,
        'car_year': car.year,
        'car_toy_num': car.toyNum ?? '',
        'car_model_name': car.modelName,
        'car_image_url': car.imageUrl,
        'car_series': car.series,
      });
    }
  }

  Future<bool> _isFavorite(HotWheelsCar car) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return false;
    final data = await _client
        .from('favorites')
        .select('user_id')
        .eq('user_id', userId)
        .eq('car_year', car.year)
        .eq('car_toy_num', car.toyNum ?? '')
        .eq('car_model_name', car.modelName)
        .limit(1);
    return (data as List).isNotEmpty;
  }

  Future<bool> isFavorite(HotWheelsCar car) => _isFavorite(car);

  Future<List<HotWheelsCar>> getFavorites() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return [];
    final data = await _client.from('favorites').select().eq('user_id', userId).order('created_at', ascending: false);
    return data.map<HotWheelsCar>((json) => HotWheelsCar(
      toyNum: json['car_toy_num'] as String?,
      modelName: json['car_model_name'] as String? ?? 'Unknown',
      year: json['car_year'] as int? ?? 0,
      imageUrl: json['car_image_url'] as String?,
      series: json['car_series'] as String?,
    )).toList();
  }

  // ──────────────────────────────────────────────
  // Friends (Phase 3)
  // ──────────────────────────────────────────────

  Future<List<Map<String, dynamic>>> searchProfiles(String query) async {
    final data = await _client.rpc('search_profiles', params: {'query': query});
    return (data as List).cast<Map<String, dynamic>>();
  }

  Future<void> sendFriendRequest(String addresseeId) async {
    final userId = _client.auth.currentUser!.id;
    await _client.from('friendships').insert({
      'requester_id': userId,
      'addressee_id': addresseeId,
      'status': 'pending',
    });
  }

  Future<void> respondToFriendRequest(String friendshipId, String status) async {
    await _client.from('friendships').update({'status': status}).eq('id', friendshipId);
  }

  Future<List<Map<String, dynamic>>> getFriends() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return [];
    final data = await _client.rpc('get_friends', params: {'p_user_id': userId});
    return (data as List).cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> getPendingRequests() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return [];
    final data = await _client
        .from('friendships')
        .select('id, requester_id, profiles!friendships_requester_id_fkey(display_name, avatar_url)')
        .eq('addressee_id', userId)
        .eq('status', 'pending');
    return (data as List).cast<Map<String, dynamic>>();
  }

  // ──────────────────────────────────────────────
  // Groups (Phase 3)
  // ──────────────────────────────────────────────

  Future<List<Map<String, dynamic>>> getUserGroups() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return [];
    final data = await _client
        .from('groups')
        .select('*, group_members!inner(user_id)')
        .eq('group_members.user_id', userId)
        .order('created_at', ascending: false);
    return (data as List).cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> createGroup(String name, {String? description}) async {
    final userId = _client.auth.currentUser!.id;
    final data = await _client.from('groups').insert({
      'name': name,
      'description': description,
      'owner_id': userId,
    }).select().single();
    // Auto-add owner as member
    await _client.from('group_members').insert({
      'group_id': data['id'],
      'user_id': userId,
    });
    return data;
  }

  Future<List<Map<String, dynamic>>> getGroupMembers(String groupId) async {
    final data = await _client
        .from('group_members')
        .select('user_id, profiles!inner(display_name, avatar_url)')
        .eq('group_id', groupId);
    return (data as List).cast<Map<String, dynamic>>();
  }

  Future<void> addMemberToGroup(String groupId, String userId) async {
    await _client.from('group_members').insert({
      'group_id': groupId,
      'user_id': userId,
    });
  }

  Future<void> shareListToGroup(String groupId, String listId) async {
    final userId = _client.auth.currentUser!.id;
    await _client.from('group_lists').insert({
      'group_id': groupId,
      'list_id': listId,
      'shared_by': userId,
    });
  }

  // ──────────────────────────────────────────────
  // View History (Phase 6)
  // ──────────────────────────────────────────────

  Future<void> recordView(HotWheelsCar car) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return;
    await _client.from('view_history').upsert({
      'user_id': userId,
      'car_year': car.year,
      'car_toy_num': car.toyNum ?? '',
      'car_model_name': car.modelName,
      'car_image_url': car.imageUrl,
      'car_series': car.series,
      'viewed_at': DateTime.now().toIso8601String(),
    });
  }

  Future<List<HotWheelsCar>> getViewHistory({int limit = 20}) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return [];
    final data = await _client
        .from('view_history')
        .select()
        .eq('user_id', userId)
        .order('viewed_at', ascending: false)
        .limit(limit);
    return data.map<HotWheelsCar>((json) => HotWheelsCar(
      toyNum: json['car_toy_num'] as String?,
      modelName: json['car_model_name'] as String? ?? 'Unknown',
      year: json['car_year'] as int? ?? 0,
      imageUrl: json['car_image_url'] as String?,
      series: json['car_series'] as String?,
    )).toList();
  }
}

class _BrandStats { int count = 0; String? imageUrl; }
class _SeriesStats { int count = 0; String? imageUrl; }
class BrandInfo { final String name; final int count; final String? imageUrl; BrandInfo({required this.name, required this.count, this.imageUrl}); }
class SeriesInfo { final String name; final int count; final String? imageUrl; SeriesInfo({required this.name, required this.count, this.imageUrl}); }
