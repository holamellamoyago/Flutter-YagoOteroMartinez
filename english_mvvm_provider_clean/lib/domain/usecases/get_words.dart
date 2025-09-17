import 'package:english_mvvm_provider_clean/domain/entities/word.dart';
import 'package:english_mvvm_provider_clean/domain/repositories/words_repository.dart';

class GetWords {
  
  WordsRepository wordsRepository;
  GetWords(this.wordsRepository);

  Future<List<Word>> call() {
    return wordsRepository.getWords();
  }
}
