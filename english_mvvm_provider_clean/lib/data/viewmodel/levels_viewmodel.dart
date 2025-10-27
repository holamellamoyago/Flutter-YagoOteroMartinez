// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:english_mvvm_provider_clean/domain/entities/level.dart';
import 'package:flutter/widgets.dart';

import 'package:english_mvvm_provider_clean/domain/repositories/database_repository.dart';

class LevelsViewmodel extends ChangeNotifier {
  final DatabaseRepository repository;

  LevelsViewmodel(this.repository) {
    loadLevels();
  }

  bool _isLoading = false;
  String _error = "";
  List<Level> _levels = [];

  List<Level> get levels => _levels;

  Future<void> loadLevels() async {
    if (_levels.isNotEmpty) {
      return;
    }

    _isLoading = true;
    _error = "";
    notifyListeners();

    try {
      _levels = await repository.getLevels();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
