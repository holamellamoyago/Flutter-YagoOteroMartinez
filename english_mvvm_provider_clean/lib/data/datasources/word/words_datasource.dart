import 'package:english_mvvm_provider_clean/domain/entities/word.dart';

// Cremaos la interfaz que después implementara cada datasource

abstract class WordsDatasource {
  Future<List<Word>> getWords(int? idLevel);
  Future<void> saveWords(List<Word> words);
  Future<void> saveOneWord(Word word);
}
