import 'package:english_mvvm_provider_clean/domain/entities/word.dart';
import 'package:english_mvvm_provider_clean/domain/repositories/words_repository.dart';

class SaveWordsUsecase {
  WordsRepository repository;
  SaveWordsUsecase(this.repository);

  Future<void> call(List<Word> words) async {
    repository.saveWords(words);
  }
}
