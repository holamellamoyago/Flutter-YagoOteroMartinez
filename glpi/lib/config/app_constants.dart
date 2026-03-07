import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:glpi/config/app_env.dart';
import 'package:glpi/domain/entities/user.dart';

class AppConstants {
  static final parameterClientID = 'client_id';
  static final parameterClientSecret = 'client_secret';
  static final parameterUsername = 'username';
  static final parameterPassword = 'password';

  // Esto es provisional hasta que implemente el login con el user.
  static final User administrator = User(
    username: AppDotEnv.administratorUsername,
    password: AppDotEnv.administratorPassword,
  );
}
