import 'package:english_mvvm_provider_clean/data/strings/app_strings.dart';
import 'package:english_mvvm_provider_clean/data/view/game_screen/game_words_widget.dart';
import 'package:english_mvvm_provider_clean/data/view/home_screen/home_screen.dart';
import 'package:english_mvvm_provider_clean/data/view/levels_screen/levels_screen.dart';
import 'package:english_mvvm_provider_clean/data/view/loggin_screen/loggin_screen.dart';
import 'package:english_mvvm_provider_clean/data/view/main_home_screen.dart';
import 'package:english_mvvm_provider_clean/data/view/profile_screen/profile_screen.dart';
import 'package:english_mvvm_provider_clean/data/view/puntuation_screen/puntuation_screen.dart';
import 'package:english_mvvm_provider_clean/data/view/social_screen/social_screen.dart';
import 'package:english_mvvm_provider_clean/data/viewmodel/auth_viewmodel.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AppRouter {
  static GoRouter createRouter(AuthViewmodel provider) {
    return GoRouter(
      initialLocation: provider.initialLocalitation,
      routes: [
        // TODO Cambiar todo esto a AppStrings
        GoRoute(path: AppStrings.mainHomeScreen, builder: (context, state) => MainHomeScreen()),
        GoRoute(
          path: '/home_screen',
          builder: (context, state) => HomeScreen(),
        ),
        GoRoute(
          path: '/game_screen',
          builder: (context, state) => GameScreen(),
        ),
        GoRoute(
          path: '/profile_screen',
          builder: (context, state) => ProfileScreen(),
        ),
        GoRoute(
          path: '/puntuation_screen',
          builder: (context, state) => PuntuationScreen(),
        ),
        GoRoute(
          path: '/social_screen',
          builder: (context, state) => SocialScreen(),
        ),

        GoRoute(
          path: AppStrings.levelsScreen,
          builder: (context, state) => LevelsScreen(),
        ),
        GoRoute(
          path: AppStrings.logginScreen,
          builder: (context, state) => LogginScreen(),
        ),
      ],
    );
  }
}
