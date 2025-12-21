// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:english_mvvm_provider_clean/domain/entities/app_user.dart';
import 'package:english_mvvm_provider_clean/domain/entities/level.dart';
import 'package:english_mvvm_provider_clean/domain/entities/level_category.dart';
import 'package:english_mvvm_provider_clean/domain/repositories/auth_repository.dart';
import 'package:flutter/widgets.dart';

import 'package:english_mvvm_provider_clean/domain/repositories/database_repository.dart';

class LevelsViewmodel extends ChangeNotifier {
  final DatabaseRepository levelRepository;
  final AuthRepository authRepository;

  LevelsViewmodel(this.levelRepository, this.authRepository) {
    _loadLevels();
    _loadCategories();
    _getLevelsCompleted();
  }

  AppUser? user;
  bool _isLoading = false;
  String _error = "";
  int? currentLevel;

  final List<Level> _levels = [];
  final List<LevelCategory> _categories = [];
  final List<Level> _levelsModified = [];
  final Map<int, bool> _levelsCopmpletedUser = {};

  LevelCategory? _selected;

  List<Level> get levels => _levelsModified;
  List<LevelCategory> get categories => _categories;
  bool get isLoading => _isLoading;
  String get error => _error;
  LevelCategory get selected => _selected ?? _categories[0];

  set selected(LevelCategory category) {
    _selected = category;
    _orderListVerbs(category.id);
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
      _levels.addAll(await levelRepository.getLevels());
      _levelsModified.addAll(_levels);
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
      _categories.add(LevelCategory(id: -1, name: "ALL"));
      _categories.addAll(await levelRepository.getLevelCategory());
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  _orderListVerbs(int codCategory) {
    _levelsModified.clear();
    _levelsModified.addAll(_levels);

    if (codCategory != -1) {
      _levelsModified.removeWhere(
        (element) => element.categoryID != codCategory,
      );
    }
  }

  Future<void> _getLevelsCompleted() async {
    _isLoading = true;
    _error = "";
    notifyListeners();

    try {
      AppUser user = await authRepository.getCurrentUser();

      _levelsCopmpletedUser.addAll(
        await levelRepository.getLevelsCompleted(user.uid),
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool isLevelCompleted(int levelID) {
    if (_levelsCopmpletedUser.containsKey(levelID) &&
        _levelsCopmpletedUser[levelID] == true) {
      return true;
    }
    return false;
  }

  Future<void> setTableCompleted(int idLevel) async {
    try {
      if (user == null) {
        await _loadInformationUser();
      }

      levelRepository.setLevelCompleted(idLevel, user!.uid);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> setNewPoints(int currentPoints) async {
    try {
      if (user == null) {
        await _loadInformationUser();
      }

      levelRepository.setNewPoints(currentPoints, user!.uid);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _loadInformationUser() async {
    user = await authRepository.getCurrentUser();
  }
}
