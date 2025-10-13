import 'package:english_mvvm_provider_clean/domain/entities/app_user.dart';
import 'package:english_mvvm_provider_clean/domain/repositories/social_repository.dart';
import 'package:flutter/widgets.dart';

class SocialViewmodel extends ChangeNotifier {
  SocialRepository socialRepository;

  SocialViewmodel(this.socialRepository) {
    getGeneralTable();
  }

  bool isLoading = false;
  String error = "";
  List<AppUser> users = [];

  Future<void> getGeneralTable() async {
    isLoading = true;
    error = "";
    notifyListeners();

    try {
      users = await socialRepository.getGeneralTable();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
