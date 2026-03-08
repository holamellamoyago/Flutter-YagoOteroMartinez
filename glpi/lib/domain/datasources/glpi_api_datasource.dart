import 'package:glpi/domain/entities/asset.dart';
import 'package:glpi/domain/entities/token.dart';

abstract class GlpiApiDatasource {
  Future<Token> getToken();
  Future<List<Asset>> getAssets(Token token);
  Future<void> authorization();
}
