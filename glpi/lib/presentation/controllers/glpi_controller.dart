import 'package:get/state_manager.dart';
import 'package:glpi/domain/usecases/glpi_api_usecase.dart';

class GlpiController extends GetxController {
  final GlpiApiUsecase _usecase;
  bool _isLoading = false;
  String _error = "";

  GlpiController({required GlpiApiUsecase usecase}) : _usecase = usecase;

  void getAssets() {
    _usecase.getAssets();
  }
}
