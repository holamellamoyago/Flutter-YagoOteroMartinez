import 'package:english_mvvm_provider_clean/domain/entities/app_user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ConvertFirebaseUsers {
  static AppUser firebaaseUserToAppUser(User firebaseUser) {
    return AppUser(
      uid: firebaseUser.uid,
      image: firebaseUser.photoURL,
      name:
          firebaseUser.displayName ??
          firebaseUser.email?.split("@")[0] ??
          'user',
      username:
          firebaseUser.displayName ??
          firebaseUser.email?.split("@")[0] ??
          'user',
      photoURL: firebaseUser.email ?? "Email user",
    );
  }
}
