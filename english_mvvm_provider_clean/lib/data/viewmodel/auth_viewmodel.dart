import 'package:carousel_slider/carousel_slider.dart';
import 'package:english_mvvm_provider_clean/data/strings/app_strings.dart';
import 'package:english_mvvm_provider_clean/data/view/loggin_screen/login_carousel_widgets.dart';
import 'package:english_mvvm_provider_clean/domain/entities/user.dart';
import 'package:english_mvvm_provider_clean/domain/repositories/auth_repository.dart';
import 'package:flutter/material.dart';

class AuthViewmodel extends ChangeNotifier {
  // Parámetros
  AuthRepository userRepository;
  bool isLoggedIn = false;
  User? currentUser;
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  String? error;
  bool isLoading = false;

  // Constructores
  AuthViewmodel(this.userRepository) {
    _checkAuth();
  }

  // GETTERS
  CarouselSliderController get carouselController => _carouselController;

  String get initialLocalitation =>
      _checkAuth() ? "/" : AppStrings.logginScreen;

  List<Widget> get carouselItems => [
    ButtonsLoginWidget(),
    RegisterEmailPassword(),
    SignInEmailPassword(),
  ];

  InputDecoration _errorDecoration(String titulo) {
    return InputDecoration(
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.redAccent),
      ),
      alignLabelWithHint: true,
      floatingLabelAlignment: FloatingLabelAlignment.start,
      labelText: titulo,
    );
  }

  InputDecoration inputDecoration(String titulo) {
    return error == null
        ? InputDecoration(
            border: OutlineInputBorder(),
            alignLabelWithHint: true,
            floatingLabelAlignment: FloatingLabelAlignment.start,
            labelText: titulo,
          )
        : _errorDecoration(error!);
  }

  // Funciones

  CarouselOptions carouselOptions(double pageHeight) {
    return CarouselOptions(viewportFraction: 1, height: pageHeight * 0.4);
  }

  bool _checkAuth() {
    return userRepository.isLoggedIn();
  }

  Future<void> loginGoogle() async {
    currentUser = await userRepository.loginWithGoogle();
  }

  Future<void> createAccountEmailPassword(String email, String password) async {
    try {
      currentUser = await userRepository.createAccountEmailPassword(
        email,
        password,
      );
    } catch (e) {
      error = e.toString();
    } 
  }


  Future<void> loginEmailPassword(String email, String password) async {
    try {
      isLoading = true;
      error = null;

      // notifyListeners();

      currentUser = await userRepository.loginWithEmail(email, password);
      isLoggedIn = true;
    } catch (e) {
      error = e.toString();
    } finally {
      // isLoading = false;
      // notifyListeners();

    }
  }

}
