import 'package:glpi/domain/datasources/glpi_api_datasource.dart';
import 'package:glpi/domain/repositories/glpi_api_repository.dart';

class GlpiApiRepositoryImpl extends GlpiApiRepository {
  final GlpiApiDatasource datasource;

  GlpiApiRepositoryImpl({required this.datasource});

  @override
  Future<int> getToken() async {
    return datasource.getToken();
  }
}
