import 'package:carousel_slider/carousel_slider.dart';
import 'package:english_mvvm_provider_clean/data/strings/app_strings.dart';
import 'package:english_mvvm_provider_clean/presentation/loggin_screen/login_carousel_widgets.dart';
import 'package:english_mvvm_provider_clean/presentation/loggin_screen/register_email_password_widget.dart';
import 'package:english_mvvm_provider_clean/presentation/loggin_screen/signin_email_password_widget.dart';
import 'package:english_mvvm_provider_clean/domain/entities/app_user.dart';
import 'package:english_mvvm_provider_clean/domain/repositories/auth_repository.dart';
import 'package:flutter/material.dart';

class AuthViewmodel extends ChangeNotifier {
  // Parámetros
  AuthRepository userRepository;
  bool isLoggedIn = false;
  AppUser? currentUser;
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  String? error;
  bool isLoading = false;

  // Constructores
  AuthViewmodel(this.userRepository) {
    Future.microtask(() async {
      await _checkAuth();
      notifyListeners(); // Notifica cambios después de chequear
    });
  }

  // GETTERS

  CarouselSliderController get carouselController => _carouselController;

  String get initialLocalitation => isLoggedIn ? "/" : AppStrings.logginScreen;

  List<Widget> get carouselItems => [
    ButtonsLoginWidget(),
    RegisterEmailPassword(),
    SignInEmailPassword(),
  ];

  Future<void> _checkAuth() async {
    if (userRepository.isLoggedIn()) {
      currentUser = await userRepository.getCurrentUser();
      isLoggedIn = true;
    } else {
      isLoggedIn = false;
    }
  }

  AppUser get getCurrentUser => currentUser!;

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
    return CarouselOptions(viewportFraction: 1);
  }

  Future<void> loginGoogle() async {
    try {
      currentUser = await userRepository.loginWithGoogle();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> createAccountEmailPassword(String email, String password) async {
    try {
      currentUser = await userRepository.createAccountEmailPassword(
        email,
        password,
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> loginEmailPassword(String email, String password) async {
    try {
      currentUser = await userRepository.loginWithEmail(email, password);
      isLoggedIn = true;
      notifyListeners();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> logOut() async {
    currentUser = null;
    userRepository.logout();
    notifyListeners();
  }

  Future<bool> loginAnonimously() async {
    try {
      currentUser = await userRepository.loginAnonimously();
      return true;
    } catch (e) {
      throw Exception(e);
    }
  }

  // User getCurrentUser() {
  //   if (currentUser != null) {
  //     return currentUser!;
  //   } else {
  //     throw Exception("No hay user");
  //   }
  // }
}
