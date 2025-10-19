import 'package:english_mvvm_provider_clean/data/viewmodel/bottombar_viewmodel.dart';
import 'package:english_mvvm_provider_clean/domain/repositories/auth_repository.dart';

class LogOutUsecase {
  AuthRepository authRepository;
  BottombarViewmodel bottombarViewmodel;

  LogOutUsecase({
    required this.authRepository,
    required this.bottombarViewmodel,
  });

  Future<void> call() async {
    bottombarViewmodel.resetIndex();
    await authRepository.logout();
  }
}
