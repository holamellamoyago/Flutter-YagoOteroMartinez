import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppDotEnv {
  static final String clientID = dotenv.env['CLIENT_ID']!;
  static final String clientSecret = dotenv.env['CLIENT_SECRET']!;

  // Esto es provisional hasta que implemente el login con el user.
  static final administratorUsername = dotenv.env['USERNAME']!;
  static final administratorPassword = dotenv.env['PASSWORD']!;
}
