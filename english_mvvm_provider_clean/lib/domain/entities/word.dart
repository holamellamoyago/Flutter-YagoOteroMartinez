import 'package:english_mvvm_provider_clean/domain/enums/WordCategory.dart';

class Word {
  String spanish;
  String english;
  int corrects;
  int errors;
  Wordcategory category;

  Word({
    required this.spanish,
    required this.english,
    required this.corrects,
    required this.errors,
    required this.category,
  });

  Word.smart({
    required this.spanish,
    required this.english,
    required this.category,
    this.corrects = 0,
    this.errors = 0,
  });

  Map<String, dynamic> toJson() => {
    'spanish': spanish,
    'english': english,
    'corrects': corrects,
    'errors': errors,
    'category': category.name,
  };

  factory Word.fromJson(Map<String, dynamic> json) => Word(
    spanish: json['spanish'],
    english: json['english'],
    corrects: json['corrects'],
    errors: json['errors'],
    category: Wordcategory.values.firstWhere(
      (e) => e.name == json['category'],
      orElse: () => Wordcategory.noun, // Valor por defecto si no encuentra
    ),
  );
}
