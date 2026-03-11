import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String geminiKEY = dotenv.env['GEMINI_APIKEY']!;
}
