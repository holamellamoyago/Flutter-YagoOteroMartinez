import 'package:glpi/domain/entities/asset.dart';
import 'package:glpi/domain/entities/token.dart';
import 'package:glpi/domain/repositories/glpi_api_repository.dart';

class GlpiApiUsecase {
  final GlpiApiRepository repository;
  Token? token;

  GlpiApiUsecase({required this.repository, this.token});

  Future<void> getAssets() async {
    token ??= await repository.getToken();
    print(token!.accessToken);

    await repository.getAssets(token!);
    // await repository.authorization();
    // print('autorizado');
  }
}
