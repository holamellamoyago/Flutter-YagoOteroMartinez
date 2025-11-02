// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:english_mvvm_provider_clean/domain/entities/vocabularyCategory.dart';

abstract class Vocabulary {
  int id;
  VocabularyCategory category;
  String english;
  String spanish;

  Vocabulary({
    required this.id,
    required this.category,
    required this.english,
    required this.spanish,
  });
}
