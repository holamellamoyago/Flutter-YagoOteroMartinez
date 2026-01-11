import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppDotenv {
  static String openAIKey = dotenv.get("DEEPSHEEK_KEY");
}
