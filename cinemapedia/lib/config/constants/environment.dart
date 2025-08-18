import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String moviedbKey = dotenv.env['THE_MOVIEDB_KEY'] ?? "No hay API KEY";
}
