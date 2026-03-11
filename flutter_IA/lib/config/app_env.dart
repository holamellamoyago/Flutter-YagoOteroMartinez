import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppEnv {
  static String geminiKEY = dotenv.env['GEMINI_APIKEY']!;
}
