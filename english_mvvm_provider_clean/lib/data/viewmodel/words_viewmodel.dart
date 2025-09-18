import 'package:english_mvvm_provider_clean/domain/enums/WordCategory.dart';
import 'package:english_mvvm_provider_clean/domain/usecases/get_words.dart';
import 'package:english_mvvm_provider_clean/domain/entities/word.dart';
import 'package:english_mvvm_provider_clean/domain/repositories/Words_repository.dart';
import 'package:english_mvvm_provider_clean/domain/usecases/save_word_usecase.dart';
import 'package:english_mvvm_provider_clean/domain/usecases/save_words_usecase.dart';
import 'package:flutter/material.dart';

class WordsViewModel extends ChangeNotifier {
  GetWords getWords;
  SaveWordUsecase saveWord;
  SaveWordsUsecase savewords;
  
  WordsViewModel(this.getWords, this.saveWord, this.savewords) {
    loadWords();
  }

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

  Future<void> saveMultipleWords(List<Word> words) async {
    try {
      loading = true;
      error = null;
      notifyListeners();

      await savewords(words);
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
