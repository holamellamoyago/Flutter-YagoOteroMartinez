import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppEnv {
  static final String keyTMDB = dotenv.env['KEY_TMDB'] ?? "No hay variable";
}
