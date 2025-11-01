// ignore_for_file: file_names

import 'package:english_mvvm_provider_clean/domain/entities/word.dart';

abstract class WordsRepository {
  Future<List<Word>> getWords(int? idLevel);
  Future<void> saveWords(List<Word> words);
  Future<void> saveOneWord(Word word);
}
