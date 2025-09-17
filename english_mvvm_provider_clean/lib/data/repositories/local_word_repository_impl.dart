import 'package:english_mvvm_provider_clean/data/datasources/local_words_datasource.dart';
import 'package:english_mvvm_provider_clean/domain/entities/word.dart';
import 'package:english_mvvm_provider_clean/domain/repositories/words_repository.dart';

class LocalWordRepositoryImpl extends WordsRepository {
  LocalWordsDatasource datasource;
  LocalWordRepositoryImpl(this.datasource);

  @override
  Future<List<Word>> getWords() {
    return datasource.getWords();
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
