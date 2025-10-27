// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:english_mvvm_provider_clean/domain/entities/level.dart';
import 'package:english_mvvm_provider_clean/domain/entities/level_category.dart';
import 'package:flutter/widgets.dart';

import 'package:english_mvvm_provider_clean/domain/repositories/database_repository.dart';

class LevelsViewmodel extends ChangeNotifier {
  final DatabaseRepository repository;

  LevelsViewmodel(this.repository) {
    _loadLevels();
    _loadCategories();
  }

  bool _isLoading = false;
  String _error = "";
  List<Level> _levels = [];
  List<LevelCategory> _categories = [];

  LevelCategory? _selected;

  List<Level> get levels => _levels;
  List<LevelCategory> get categories => _categories;
  bool get isLoading => _isLoading;
  String get error => _error;
  LevelCategory get selected => _selected ?? _categories[0];

  set selected(LevelCategory category) {
    _selected = category;
    notifyListeners();
  }

  Future<void> _loadLevels() async {
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

  Future<void> _loadCategories() async {
    if (_categories.isNotEmpty) {
      return;
    }

    _isLoading = true;
    _error = "";
    notifyListeners();

    try {
      _categories = await repository.getLevelCategory();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
