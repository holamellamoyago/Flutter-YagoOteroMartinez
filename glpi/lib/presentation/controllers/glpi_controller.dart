import 'package:get/state_manager.dart';
import 'package:glpi/domain/usecases/glpi_api_usecase.dart';

class GlpiController extends GetxController {
  final GlpiApiUsecase usecase;
  bool isLoading = false;
  String error = "";

  GlpiController({required this.usecase});

  // TODO Probar sin future
  Future<void> getAssets() async {
    print('Llego al controller');
    usecase.getAssets();
  }
}
