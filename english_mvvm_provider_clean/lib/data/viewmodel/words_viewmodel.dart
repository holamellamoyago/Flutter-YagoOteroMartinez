import 'package:english_mvvm_provider_clean/domain/entities/word.dart';
import 'package:english_mvvm_provider_clean/domain/repositories/words_repository.dart';
import 'package:english_mvvm_provider_clean/domain/usecases/save_word_usecase.dart';
import 'package:english_mvvm_provider_clean/domain/usecases/save_words_usecase.dart';
import 'package:flutter/material.dart';

class WordsViewModel extends ChangeNotifier {
  WordsRepository wordRepository;
  SaveWordUsecase saveWord;
  SaveWordsUsecase savewords;

  WordsViewModel(this.wordRepository, this.saveWord, this.savewords);

  List<Word>? words = [];
  bool loading = false;
  String? error;
  Word? word;

  Future<void> loadWords(int? idLevel) async {
    try {
      loading = true;
      error = null;
      notifyListeners();

      words = await wordRepository.getWords(idLevel);
    } catch (e) {
      error = e.toString();
      print(error);
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
