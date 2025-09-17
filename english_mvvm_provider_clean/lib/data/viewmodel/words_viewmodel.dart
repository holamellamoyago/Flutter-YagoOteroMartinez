import 'package:english_mvvm_provider_clean/domain/usecases/get_words.dart';
import 'package:english_mvvm_provider_clean/domain/entities/word.dart';
import 'package:english_mvvm_provider_clean/domain/repositories/Words_repository.dart';
import 'package:english_mvvm_provider_clean/domain/usecases/save_word_usecase.dart';
import 'package:flutter/material.dart';

class WordsViewModel extends ChangeNotifier {
  GetWords getWords;
  SaveWordUsecase saveWord;
  WordsViewModel(this.getWords, this.saveWord);

  List<Word>? words = [];
  bool loading = false;
  String? error;
  Word? word;

  Future<void> loadWords() async {
    try {
      loading = true;
      error = null;
      notifyListeners();

      words = await getWords();
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> saveOneWord(Word word) async {
    try {
      loading = true;
      error = null;
      notifyListeners();

      await saveWord(word);
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
