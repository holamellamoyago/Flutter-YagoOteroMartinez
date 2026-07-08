import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'theme/hw_theme.dart';
import 'controllers/filter_controller.dart';
import 'screens/home_screen.dart';

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
    // Initialize global controllers
    Get.put(FilterController());
    
    return GetMaterialApp(
      title: 'Hot Wheels',
      debugShowCheckedModeBanner: false,
      theme: HwTheme.dark,
      home: const HomeScreen(),
    );
  }
}
