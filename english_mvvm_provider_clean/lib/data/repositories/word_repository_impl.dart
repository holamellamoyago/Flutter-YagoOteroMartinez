import 'package:english_mvvm_provider_clean/data/datasources/word/words_datasource.dart';
import 'package:english_mvvm_provider_clean/domain/entities/word.dart';
import 'package:english_mvvm_provider_clean/domain/repositories/words_repository.dart';

class WordRepositoryImpl implements WordsRepository {
  final WordsDatasource datasource;
  WordRepositoryImpl(this.datasource);

  @override
  Future<List<Word>> getWords(int? idLevel) {
    return datasource.getWords(idLevel);
  }

  @override
  Future<void> saveWords(List<Word> words) async {
    datasource.saveWords(words);
  }

  @override
  Future<void> saveOneWord(Word word) async {
    datasource.saveOneWord(word);
  }
}
