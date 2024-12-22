import 'package:flutter_dotenv/flutter_dotenv.dart';

class environment {
  static String supabase_url = dotenv.env['SUPABASE_URL'] ?? 'Error supabase_url';
  static String supabase_key = dotenv.env['SUPABASE_KEY'] ?? 'Error supabase_url';
}