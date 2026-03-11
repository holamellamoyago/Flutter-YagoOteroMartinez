import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String firebasekeyAndroid =
      dotenv.env['FIREBASEKEY_ANDROID'] ?? 'no api key';
  static String firebasekeyWeb = dotenv.env['FIREBASEKEY_WEB'] ?? 'no api key';
  static String firebasekeyIos = dotenv.env['FIREBASEKEY_IOS'] ?? 'no api key';
  static String stripeKey = dotenv.env['STRIPE_PUBLIC_KEY'] ?? 'Error';
}
