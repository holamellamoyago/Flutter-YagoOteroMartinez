// ignore_for_file: file_names

import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String supabaseUrl = dotenv.env['SUPABASE_URL'] ?? 'Error supabase_url';
  static String supabaseKey = dotenv.env['SUPABASE_KEY'] ?? 'Error supabase_url';
  static String firebaseWebKey = dotenv.env['FIREBASE_WEB_KEY'] ?? 'No firebase web key';
  static String firebaseAndroidKey = dotenv.env['FIREBASE_Android_KEY'] ?? 'No firebase Android key';
  static String firebaseIOSKey = dotenv.env['FIREBASE_IOS_KEY'] ?? 'No firebase IOS key';
}