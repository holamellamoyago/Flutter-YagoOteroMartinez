import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/pending_link_service.dart';

class AuthController extends GetxController {
  final _client = Supabase.instance.client;
  final user = Rxn<User>();
  final isLoggedIn = false.obs;
  final loading = true.obs;

  static AuthController get to => Get.find<AuthController>();

  // Google Sign-In client (native mobile only)
  GoogleSignIn? _googleSignIn;

  @override
  void onInit() {
    super.onInit();

    // Init Google Sign-In on mobile only (web uses Supabase OAuth popup)
    if (!kIsWeb) {
      _googleSignIn = GoogleSignIn(
        clientId:
            '621549090806-20cjrpiv64an3p6qil1b8vh06hirjcv6.apps.googleusercontent.com',
      );
    }

    // Listen for session changes
    _client.auth.onAuthStateChange.listen((data) {
      user.value = data.session?.user;
      isLoggedIn.value = data.session != null;
      loading.value = false;
      if (data.session != null) _onLogin();
    });

    // Recover existing session
    _recoverSession();

    // Timeout: if no session after 3s, assume not logged in
    Future.delayed(const Duration(seconds: 3), () {
      if (loading.value) loading.value = false;
    });
  }

  Future<void> _recoverSession() async {
    try {
      final session = _client.auth.currentSession;
      if (session != null) {
        user.value = session.user;
        isLoggedIn.value = true;
      }
    } catch (_) {}
  }

  void _onLogin() {
    if (Get.isRegistered<PendingLinkService>()) {
      Get.find<PendingLinkService>().dispatch();
    }
  }

  /// Google Sign-In: native on mobile, Supabase popup on web
  Future<void> signInWithGoogle() async {
    if (kIsWeb) {
      // Web: Supabase handles the popup natively
      await _client.auth.signInWithOAuth(OAuthProvider.google);
      return;
    }

    // Mobile: google_sign_in native dialog → idToken → Supabase
    try {
      final googleUser = await _googleSignIn!.signIn();
      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;

      if (idToken == null) {
        Get.snackbar('Error', 'Failed to get Google ID token',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: const Color(0xFFB71C1C),
            colorText: const Color(0xFFFFFFFF));
        return;
      }

      await _client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: googleAuth.accessToken,
      );
    } on Exception catch (e) {
      final msg = e.toString();
      if (msg.contains('SIGN_IN_CANCELLED') || msg.contains('SIGN_IN_REQUIRED')) {
        return;
      }
      Get.snackbar('Google Sign-In Error', 'Sign in failed. Try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFB71C1C),
          colorText: const Color(0xFFFFFFFF));
    } catch (e) {
      Get.snackbar('Error', 'Sign in failed. Try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFB71C1C),
          colorText: const Color(0xFFFFFFFF));
    }
  }

  Future<void> signInWithApple() =>
      _client.auth.signInWithOAuth(OAuthProvider.apple);

  Future<void> signInWithFacebook() =>
      _client.auth.signInWithOAuth(OAuthProvider.facebook);

  Future<void> signOut() async {
    await _client.auth.signOut();
    if (!kIsWeb) await _googleSignIn?.signOut();
    user.value = null;
    isLoggedIn.value = false;
  }
}
