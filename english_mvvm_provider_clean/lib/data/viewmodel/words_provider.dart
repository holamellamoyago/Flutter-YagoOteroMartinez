import 'package:english_mvvm_provider_clean/domain/entities/word.dart';
import 'package:english_mvvm_provider_clean/domain/repositories/Words_repository.dart';
import 'package:flutter/material.dart';

class WordsProvider extends ChangeNotifier {
  WordsRepository repository;
  WordsProvider(this.repository);

  List<Word> words = [];
  bool loading = false;
  String? error;

  Future<void> getWords() async {
    try {
      loading = true;
      error = null;
      notifyListeners();

      words = await repository.getWords();
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
