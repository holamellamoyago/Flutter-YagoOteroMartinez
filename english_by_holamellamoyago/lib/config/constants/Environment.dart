// ignore_for_file: file_names

import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String supabaseUrl = dotenv.env['SUPABASE_URL'] ?? 'Error supabase_url';
  static String supabaseKey = dotenv.env['SUPABASE_KEY'] ?? 'Error supabase_url';
}