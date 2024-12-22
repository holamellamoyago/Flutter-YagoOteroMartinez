

import 'package:english_by_holamellamoyago/presentation/screens.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
    WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: 'https://ohnbdtecylptrfjfsmvv.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9obmJkdGVjeWxwdHJmamZzbXZ2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzI5MjM2OTQsImV4cCI6MjA0ODQ5OTY5NH0.xQ1d_ne3ugHlXMG8WhM0DU_OiG_rAxIoyxiIg7Gm6ZQ',
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
