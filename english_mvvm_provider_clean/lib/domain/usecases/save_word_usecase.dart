import 'package:english_mvvm_provider_clean/domain/entities/word.dart';
import 'package:english_mvvm_provider_clean/domain/repositories/words_repository.dart';

class SaveWordUsecase {
  WordsRepository repository;
  SaveWordUsecase(this.repository);

  Future<void> call(Word word) async {
    repository.saveOneWord(word);
  }
}
