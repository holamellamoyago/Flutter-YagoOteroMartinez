import 'package:english_mvvm_provider_clean/data/view/home_screen/home_screen.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => HomeScreen()),
    ],
  );
}
