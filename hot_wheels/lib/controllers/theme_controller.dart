import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  static ThemeController get to => Get.find<ThemeController>();

  final isDark = true.obs;

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    isDark.value = prefs.getBool('theme_dark') ?? true;
  }

  Future<void> toggle() async {
    isDark.toggle();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('theme_dark', isDark.value);
  }
}
