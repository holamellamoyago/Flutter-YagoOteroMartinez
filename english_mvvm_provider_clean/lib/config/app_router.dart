import 'package:english_mvvm_provider_clean/data/strings/app_strings.dart';
import 'package:english_mvvm_provider_clean/presentation/game_screen/game_words_widget.dart';
import 'package:english_mvvm_provider_clean/presentation/home_screen/home_screen.dart';
import 'package:english_mvvm_provider_clean/presentation/levels_screen/levels_screen.dart';
import 'package:english_mvvm_provider_clean/presentation/loggin_screen/loggin_screen.dart';
import 'package:english_mvvm_provider_clean/presentation/main_home_screen.dart';
import 'package:english_mvvm_provider_clean/presentation/settings_screen/settings_screen.dart';
import 'package:english_mvvm_provider_clean/presentation/puntuation_screen/puntuation_screen.dart';
import 'package:english_mvvm_provider_clean/presentation/social_screen/social_screen.dart';
import 'package:english_mvvm_provider_clean/data/viewmodel/auth_viewmodel.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static GoRouter createRouter(AuthViewmodel provider) {
    return GoRouter(
      initialLocation: provider.initialLocalitation,
      routes: [
        // TODO Cambiar todo esto a AppStrings
        GoRoute(
          path: AppStrings.mainHomeScreen,
          builder: (context, state) => MainHomeScreen(),
        ),
        GoRoute(
          path: AppStrings.homeScreen,
          builder: (context, state) => HomeScreen(),
        ),
        GoRoute(
          path: AppStrings.gameScreen,
          builder: (context, state) => GameScreen(),
        ),
        GoRoute(
          path: AppStrings.profileScreen,
          builder: (context, state) => SettingsScreen(),
        ),
        GoRoute(
          path: AppStrings.puntuationScreen,
          builder: (context, state) => PuntuationScreen(),
        ),
        GoRoute(
          path: AppStrings.socialScreen,
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
