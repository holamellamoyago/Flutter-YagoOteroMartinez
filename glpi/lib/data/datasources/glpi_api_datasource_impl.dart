import 'package:dio/dio.dart';
import 'package:glpi/config/app_constants.dart';
import 'package:glpi/config/app_env.dart';
import 'package:glpi/domain/datasources/glpi_api_datasource.dart';

class GlpiApiDatasourceImpl extends GlpiApiDatasource {
  static String baseURL = 'https://yagootero.fr34.glpi-network.cloud/api.php';
  static String contentType = 'application/json';

  final dio = Dio(BaseOptions(baseUrl: baseURL, contentType: contentType));

  @override
  Future<int> getToken() async {
    final String uriToken = '/token';

    try {
      final json = await dio.post(
        uriToken,
        data: {
          AppConstants.parameterClientID: AppDotEnv.clientID,
          AppConstants.parameterClientSecret: AppDotEnv.clientSecret,
          AppConstants.parameterUsername: AppDotEnv.administratorUsername,
          AppConstants.parameterPassword: AppDotEnv.administratorPassword,
          'grant_type': 'password',
          'scope': 'api',
        },
      );

      print(json.data);
    } catch (e) {
      print(e.toString());
    }

    // print(json.toString());

    return 0;
  }
}
