import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'theme/hw_theme.dart';
import 'controllers/auth_controller.dart';
import 'controllers/filter_controller.dart';
import 'controllers/friends_controller.dart';
import 'controllers/lists_controller.dart';
import 'controllers/theme_controller.dart';
import 'services/deep_link_service.dart';
import 'services/pending_link_service.dart';
import 'screens/main_screen.dart';

final themeCtrl = Get.put(ThemeController());

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    publishableKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
  runApp(const HotWheelsApp());
}

class HotWheelsApp extends StatelessWidget {
  const HotWheelsApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(FilterController());
    Get.put(AuthController());
    Get.put(PendingLinkService());
    Get.put(ListsController());
    Get.put(FriendsController());
    DeepLinkService().init();

    return Obx(() => GetMaterialApp(
      title: 'Hot Wheels',
      debugShowCheckedModeBanner: false,
      theme: themeCtrl.isDark.value ? HwTheme.dark : HwTheme.light,
      home: const MainScreen(),
    ));
  }
}
