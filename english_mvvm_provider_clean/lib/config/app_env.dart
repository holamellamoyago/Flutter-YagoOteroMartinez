import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppEnv {
  static final String webApiKey = dotenv.env['WEB_apiKey']!;
  static final String androidApiKey = dotenv.env['Android_apiKey']!;
  static final String iosApiKey = dotenv.env['IOS_apiKey']!;
  static final String macosApiKey = dotenv.env['MacOS_apiKey']!;
  static final String windowsApiKey = dotenv.env['Windows_apiKey']!;
  static final String supabaseURL = dotenv.env['SUPABASE_URL']!;
  static final String supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY']!;
  static final String androidAppCheck = dotenv.env['ANDROID_APPCHECK']!;
  
  // static final String googleServerClientID = dotenv.env['ServerClientIdAutenticacionGoogle']!;
}
