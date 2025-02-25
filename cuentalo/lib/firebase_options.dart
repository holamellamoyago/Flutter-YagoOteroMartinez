// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBRzDo_nopOBw0IfqOI_iTdkdGpNbArx1Y',
    appId: '1:1050588380052:web:393ab3a57f19f20b83ed81',
    messagingSenderId: '1050588380052',
    projectId: 'hiitgym-2ae99',
    authDomain: 'hiitgym-2ae99.firebaseapp.com',
    databaseURL: 'https://hiitgym-2ae99-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'hiitgym-2ae99.appspot.com',
    measurementId: 'G-6G937QH87S',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD4yFF7CNh-xPouXaAa44uDD9eVZmOQTfU',
    appId: '1:1050588380052:android:7503b9dd4ca0573e83ed81',
    messagingSenderId: '1050588380052',
    projectId: 'hiitgym-2ae99',
    databaseURL: 'https://hiitgym-2ae99-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'hiitgym-2ae99.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBHEIvhcwH016hP5fcyr917yoU62hifHVw',
    appId: '1:1050588380052:ios:c90b469cd2e866c483ed81',
    messagingSenderId: '1050588380052',
    projectId: 'hiitgym-2ae99',
    databaseURL: 'https://hiitgym-2ae99-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'hiitgym-2ae99.appspot.com',
    androidClientId: '1050588380052-37oag1gu9s9in7bupgon7od7n2id33cg.apps.googleusercontent.com',
    iosClientId: '1050588380052-sgkjg02bjf2rvk3pj37vc67g2fnpg75l.apps.googleusercontent.com',
    iosBundleId: 'com.example.cuentalo',
  );
}
