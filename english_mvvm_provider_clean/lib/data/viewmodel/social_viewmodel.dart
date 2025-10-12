import 'package:english_mvvm_provider_clean/domain/repositories/social_repository.dart';
import 'package:flutter/widgets.dart';

class SocialViewmodel extends ChangeNotifier {
  SocialRepository socialRepository;
  SocialViewmodel({required this.socialRepository});

  bool isLoading = false;

  getGeneralTable() {
    socialRepository.getGeneralTable();
  }
}
