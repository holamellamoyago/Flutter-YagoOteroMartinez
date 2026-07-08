import 'package:get/get.dart';
import '../models/hot_wheels_car.dart';
import '../services/supabase_service.dart';

class YearsController extends GetxController {
  final _service = SupabaseService();
  final years = <int>[].obs;
  final loading = true.obs;
  final error = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    loading.value = true;
    error.value = null;
    try {
      years.value = await _service.getAvailableYears();
    } catch (e) {
      error.value = e.toString();
    } finally {
      loading.value = false;
    }
  }
}

class CarsController extends GetxController {
  final _service = SupabaseService();
  final cars = <HotWheelsCar>[].obs;
  final loading = true.obs;
  final int year;

  CarsController(this.year);

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    loading.value = true;
    try {
      cars.value = await _service.getCarsByYear(year);
    } catch (_) {} finally {
      loading.value = false;
    }
  }
}

class CarSearchController extends GetxController {
  final _service = SupabaseService();
  final results = <HotWheelsCar>[].obs;
  final searching = false.obs;
  final query = ''.obs;

  Future<void> search(String q) async {
    if (q.trim().length < 2) return;
    searching.value = true;
    query.value = q.trim();
    try {
      results.value = await _service.searchCars(q.trim());
    } catch (_) {} finally {
      searching.value = false;
    }
  }
}
