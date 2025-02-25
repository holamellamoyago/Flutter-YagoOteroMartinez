

import 'package:english_by_holamellamoyago/config/constants/Jugador.dart';
import 'package:english_by_holamellamoyago/firebase_options.dart';
import 'package:english_by_holamellamoyago/presentation/screens.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async {
    WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  await Verbo.init();
  await Partida.init();
  await Jugador.init();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
      
);

  await Supabase.initialize(
    url: Environment.supabaseUrl,
    anonKey: Environment.supabaseKey,
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
