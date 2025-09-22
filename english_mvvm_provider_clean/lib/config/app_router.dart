import 'package:english_mvvm_provider_clean/data/view/game_screen/game_words_widget.dart';
import 'package:english_mvvm_provider_clean/data/view/home_screen/home_screen.dart';
import 'package:english_mvvm_provider_clean/data/view/main_home_screen.dart';
import 'package:english_mvvm_provider_clean/data/view/profile_screen/profile_screen.dart';
import 'package:english_mvvm_provider_clean/data/view/puntuation_screen/puntuation_screen.dart';
import 'package:english_mvvm_provider_clean/data/view/social_screen/social_screen.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => MainHomeScreen()),
      GoRoute(path: '/home_screen', builder: (context, state) => HomeScreen()),
      GoRoute(path: '/game_screen', builder: (context, state) => GameScreen()),
      GoRoute(path: '/profile_screen', builder: (context, state) => ProfileScreen()),
      GoRoute(path: '/puntuation_screen', builder: (context, state) => PuntuationScreen()),
      GoRoute(path: '/social_screen', builder: (context, state) => SocialScreen()),
    ],
  );
}
