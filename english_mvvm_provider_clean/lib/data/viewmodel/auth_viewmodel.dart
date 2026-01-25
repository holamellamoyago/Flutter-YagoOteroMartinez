import 'package:carousel_slider/carousel_slider.dart';
import 'package:english_mvvm_provider_clean/data/strings/app_strings.dart';
import 'package:english_mvvm_provider_clean/domain/usecases/log_out_usecase.dart';
import 'package:english_mvvm_provider_clean/presentation/loggin_screen/login_carousel_widgets.dart';
import 'package:english_mvvm_provider_clean/presentation/loggin_screen/register_email_password_widget.dart';
import 'package:english_mvvm_provider_clean/presentation/loggin_screen/signin_email_password_widget.dart';
import 'package:english_mvvm_provider_clean/domain/entities/app_user.dart';
import 'package:english_mvvm_provider_clean/domain/repositories/auth_repository.dart';
import 'package:english_mvvm_provider_clean/utils/convert_firebase_users.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthViewmodel extends ChangeNotifier {
  // Parámetros
  AuthRepository authRepository;
  bool isLoggedIn = false;
  AppUser? currentUser;
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  String? error;
  bool isLoading = false;

  // usecases
  LogOutUsecase logOutUsecase;

  // Constructores
  AuthViewmodel(this.authRepository, this.logOutUsecase) {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      currentUser = user != null
          ? ConvertFirebaseUsers.firebaaseUserToAppUser(user)
          : null;
      isLoggedIn = user != null ? true : false;
      notifyListeners();
    });

    Future.microtask(() async {
      await _checkAuth();
      notifyListeners(); // Notifica cambios después de chequear
    });
  }

  // Estaticos
  static const List<Widget> carouselItems = [
    ButtonsLoginWidget(),
    RegisterEmailPassword(),
    SignInEmailPassword(),
  ];

  // GETTERS

  CarouselSliderController get carouselController => _carouselController;

  // String get initialLocalitation => isLoggedIn ? "/" : AppStrings.logginScreen;
  String get initialLocalitation => isLoggedIn ? AppStrings.puntuationScreen : AppStrings.logginScreen;

  Future<void> _checkAuth() async {
    if (authRepository.isLoggedIn()) {
      currentUser = await authRepository.getCurrentUser();
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
      currentUser = await authRepository.loginWithGoogle();
      // TODO Integrar consuopabase
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> createAccountEmailPassword(String email, String password) async {
    try {
      currentUser = await authRepository.createAccountEmailPassword(
        email,
        password,
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> loginEmailPassword(String email, String password) async {
    try {
      currentUser = await authRepository.loginWithEmail(email, password);
      isLoggedIn = true;
      notifyListeners();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> logOut() async {
    await logOutUsecase();
    notifyListeners();
  }

  Future<bool> loginAnonimously() async {
    try {
      currentUser = await authRepository.loginAnonimously();
      return true;
    } catch (e) {
      throw Exception(e);
    }
  }
}
