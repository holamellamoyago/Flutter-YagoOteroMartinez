import 'package:english_mvvm_provider_clean/config/app_router.dart';
import 'package:english_mvvm_provider_clean/data/strings/app_strings.dart';
import 'package:english_mvvm_provider_clean/data/view/loggin_screen/loggin_screen.dart';
import 'package:english_mvvm_provider_clean/domain/entities/user.dart';
import 'package:english_mvvm_provider_clean/domain/repositories/auth_repository.dart';
import 'package:flutter/material.dart';

class AuthViewmodel extends ChangeNotifier {
  AuthRepository userRepository;

  // String _initialLocalitation;
  bool isLoggedIn = false;
  User? currentUser;
  bool _isLoading = false;

  AuthViewmodel(this.userRepository) {
    _checkAuth();
  }

  String get initialLocalitation =>
      _checkAuth() ? "/" : AppStrings.logginScreen;

  bool _checkAuth() {
    return userRepository.isLoggedIn();
  }

  // void loadUser() {
  //   if (userRepository.isLoggedIn()) {
  //     AppRouter.initialLocation = "/";
  //   } else {
  //     AppRouter.initialLocation = AppStrings.logginScreen;
  //   }
  // }
}
