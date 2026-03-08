import 'package:dio/dio.dart';
import 'package:glpi/config/app_constants.dart';
import 'package:glpi/config/app_env.dart';
import 'package:glpi/domain/datasources/glpi_api_datasource.dart';
import 'package:glpi/domain/entities/asset.dart';
import 'package:glpi/domain/entities/token.dart';

class GlpiApiDatasourceImpl extends GlpiApiDatasource {
  static String baseURL = 'https://yagootero.fr34.glpi-network.cloud/api.php';
  static String contentType = 'application/json';

  final dio = Dio(BaseOptions(baseUrl: baseURL, contentType: contentType));

  @override
  Future<Token> getToken() async {
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

      return Token.fromJson(json.data);
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<List<Asset>> getAssets(Token token) async {
    final String uriAssets = '/Assets/';
    Map<String, String> queries = {
      'Authorization': '${token.tokenType} ${token.accessToken}',
    };

    print(queries);

    try {
      final json = await dio.get(
        uriAssets,
        queryParameters: queries,
        // queryParameters: {'Authorization': 'Bearer ${token.accessToken}'},
        // options: Options(
        //   data: {
        //     // AppConstants.parameterAuthorization: ' Bearer ${token.accessToken}',
        //     'Authorization': 'Bearer ${token.accessToken}',
        //   },
        // ),
      );

      print(json.data);
      List<Asset> assets = json.data;
      return assets;
    } catch (e) {
      print('Hubo un error: ' + e.toString());
      throw e.toString();
    }
  }

  @override
  Future<void> authorization() async {
    final String uriAuthorize = '/authorize';

    try {
      final json = await dio.get(
        uriAuthorize,
        data: {
          'response_type': 'code',
          'client_id': AppDotEnv.clientID,
          'scope': 'api',
        },
      );

      print(json.data);
    } catch (e) {
      throw e.toString();
    }
  }
}
