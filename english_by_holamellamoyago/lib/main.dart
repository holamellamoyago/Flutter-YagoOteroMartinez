

import 'package:english_by_holamellamoyago/presentation/screens.dart';


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
    return Sizer(
      builder: (context, orientation, deviceType) => MaterialApp.router(
        routerConfig: appRouter,
      ),
    );
  }
}
