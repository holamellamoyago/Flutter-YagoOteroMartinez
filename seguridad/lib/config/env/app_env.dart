import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppEnv {
  final String a = dotenv.env['KEY_TMDB'] ?? "No hay variable";
}
