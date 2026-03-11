import 'package:dio/dio.dart';
import 'package:flutter_ia/config/app_constants.dart';
import 'package:flutter_ia/config/app_env.dart';
import 'package:flutter_ia/data/entities/entities.dart';
import 'package:flutter_ia/domain/datasources/ia_datasource.dart';

class IADatasourceGeminiImpl extends IaDatasource {
  static String baseURL =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-3-flash-preview:generateContent";

  final Dio dio = Dio(
    BaseOptions(
      baseUrl: baseURL,
      contentType: 'application/json',
      headers: {AppConstants.parameterGeminiApiKEY: AppEnv.geminiKEY},
    ),
  );

  @override
  Future<String> sendMessage(Contents contents) async {
    print(contents.toJson());

    final json = await dio.post('', data: contents.toJson());

    print(json.data);

    return "";
  }
}
