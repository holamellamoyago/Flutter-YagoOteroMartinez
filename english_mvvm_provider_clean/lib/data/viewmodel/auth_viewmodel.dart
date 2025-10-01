import 'package:carousel_slider/carousel_slider.dart';
import 'package:english_mvvm_provider_clean/data/strings/app_strings.dart';
import 'package:english_mvvm_provider_clean/data/view/loggin_screen/login_carousel_widgets.dart';
import 'package:english_mvvm_provider_clean/domain/entities/user.dart';
import 'package:english_mvvm_provider_clean/domain/repositories/auth_repository.dart';
import 'package:flutter/material.dart';

class AuthViewmodel extends ChangeNotifier {
  AuthRepository userRepository;

  bool isLoggedIn = false;
  User? currentUser;
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  AuthViewmodel(this.userRepository) {
    _checkAuth();
  }

  String get initialLocalitation =>
      _checkAuth() ? "/" : AppStrings.logginScreen;

  CarouselSliderController get carouselController => _carouselController;

  CarouselOptions get carouselOptions => CarouselOptions(viewportFraction: 1);

  List<StatelessWidget> get carouselItems => [ButtonsLoginWidget(), TextFieldsEmailPassword()];

  bool _checkAuth() {
    return userRepository.isLoggedIn();
  }

  Future<void> loginGoogle() async {
    currentUser = await userRepository.loginWithGoogle();
  }

  Future<void> loginEmailPassword(String email, String password) async {
    currentUser = await userRepository.loginWithEmail(email, password);
  }
}
