import 'package:english_mvvm_provider_clean/data/strings/app_strings.dart';
import 'package:english_mvvm_provider_clean/domain/entities/user.dart';
import 'package:english_mvvm_provider_clean/domain/repositories/auth_repository.dart';
import 'package:flutter/material.dart';

class AuthViewmodel extends ChangeNotifier {
  AuthRepository userRepository;

  // String _initialLocalitation;
  bool isLoggedIn = false;
  User? currentUser;
  // bool _isLoading = false;

  AuthViewmodel(this.userRepository) {
    _checkAuth();
  }

  String get initialLocalitation =>
      _checkAuth() ? "/" : AppStrings.logginScreen;

  bool _checkAuth() {
    return userRepository.isLoggedIn();
  }

  Future<void> loginGoogle() async {
    currentUser=  await userRepository.loginWithGoogle();

  }
}
