import 'package:glpi/domain/datasources/glpi_api_datasource.dart';
import 'package:glpi/domain/entities/asset.dart';
import 'package:glpi/domain/entities/token.dart';
import 'package:glpi/domain/repositories/glpi_api_repository.dart';

class GlpiApiRepositoryImpl extends GlpiApiRepository {
  final GlpiApiDatasource datasource;

  GlpiApiRepositoryImpl({required this.datasource});

  @override
  Future<Token> getToken() async {
    return datasource.getToken();
  }

  @override
  Future<List<Asset>> getAssets(Token token) {
    return datasource.getAssets(token);
  }

  @override
  Future<void> authorization() {
    return datasource.authorization();
  }
}
