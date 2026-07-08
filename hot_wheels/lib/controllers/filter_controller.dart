import 'package:get/get.dart';
import '../models/hot_wheels_car.dart';
import '../services/supabase_service.dart';

class FilterController extends GetxController {
  final _service = SupabaseService();

  // Filters
  final query = ''.obs;
  final selectedBrand = Rxn<String>();
  final selectedSeries = Rxn<String>();
  final selectedYear = Rxn<int>();

  // Options
  final brands = <String>[].obs;
  final series = <String>[].obs;
  final years = <int>[].obs;
  final loadingOptions = true.obs;

  // Results
  final results = <HotWheelsCar>[].obs;
  final searching = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadOptions();
  }

  Future<void> _loadOptions() async {
    loadingOptions.value = true;
    try {
      final results = await Future.wait([
        _service.getBrands(),
        _service.getSeries(),
        _service.getAvailableYears(),
      ]);
      brands.value = results[0] as List<String>;
      series.value = results[1] as List<String>;
      years.value = results[2] as List<int>;
    } catch (_) {} finally {
      loadingOptions.value = false;
    }
  }

  Future<void> search() async {
    searching.value = true;
    try {
      results.value = await _service.searchByFilters(
        query: query.value.isEmpty ? null : query.value,
        brand: selectedBrand.value,
        series: selectedSeries.value,
        year: selectedYear.value,
      );
    } catch (_) {
      results.clear();
    } finally {
      searching.value = false;
    }
  }

  void clearFilters() {
    query.value = '';
    selectedBrand.value = null;
    selectedSeries.value = null;
    selectedYear.value = null;
    results.clear();
  }

  bool get hasFilters =>
      query.isNotEmpty ||
      selectedBrand.value != null ||
      selectedSeries.value != null ||
      selectedYear.value != null;
}
