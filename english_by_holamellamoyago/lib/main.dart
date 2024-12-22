

import 'package:english_by_holamellamoyago/config/constants/Environment.dart';
import 'package:english_by_holamellamoyago/presentation/screens.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
    WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: environment.supabase_url,
    anonKey: environment.supabase_key,
  );

  runApp(const MyApp());
} 

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Sizer(
      builder: (context, orientation, deviceType) => MaterialApp.router(
        routerConfig: appRouter,
      ),
    );
  }
}
