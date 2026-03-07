import 'package:glpi/domain/entities/token.dart';
import 'package:glpi/domain/repositories/glpi_api_repository.dart';

class GlpiApiUsecase {
  final GlpiApiRepository repository;
  final Token? token;

  GlpiApiUsecase({required this.repository, this.token});

  void getAssets() {
    if (token == null) {
      repository.getToken();
    }

    // TODO Trabajar ya con el token, paso a paso 
  }
}
