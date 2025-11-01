import 'dart:ffi';

import 'package:english_mvvm_provider_clean/config/database_constants.dart';
import 'package:english_mvvm_provider_clean/data/datasources/word/words_datasource.dart';
import 'package:english_mvvm_provider_clean/domain/entities/word.dart';
import 'package:english_mvvm_provider_clean/domain/enums/WordCategory.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseWordsDatasource implements WordsDatasource {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Esta función tarda 0 seg mas que la optimizada !! 
  // @override
  // Future<List<Word>> getWords(int? idLevel) async {
  //   List<Word> words = [];

  //   List<Map<String, dynamic>> vocabularyLevel = await _supabase
  //       .from(DatabaseConstants.tableVocabularyLevel)
  //       .select(DatabaseConstants.vocabularyID)
  //       .filter(DatabaseConstants.levelID, 'eq', idLevel);

  //   for (var i = 0; i < vocabularyLevel.length; i++) {
  //     Map<String, dynamic> individual = vocabularyLevel[i];
  //     int vocabularyID = individual["vocabulary_id"];

  //     List<Map<String, dynamic>> getPalabra = await _supabase
  //         .from("vocabulary")
  //         .select()
  //         .eq("id_vocabulary", vocabularyID);

  //     Map<String, dynamic> palabraIndividual = getPalabra[0];
  //     String english = palabraIndividual["english"];
  //     String spanish = palabraIndividual["spanish"];

  //     Word word = Word.smart(
  //       spanish: spanish,
  //       english: english,
  //       category: Wordcategory.phrasalverb,
  //     );

  //     words.add(word);
  //   }

  //   return words;
  // }

  @override
  Future<List<Word>> getWords(int? idLevel) async {
    List<Word> words = [];

    try {
      List<Map<String, dynamic>> data = await _supabase
          .from(DatabaseConstants.tableVocabularyLevel)
          .select('''
          ${DatabaseConstants.tableVocabulary}!inner (
            ${DatabaseConstants.idVocabulary},
            ${DatabaseConstants.english},
            ${DatabaseConstants.spanish})
        ''')
          .eq(DatabaseConstants.levelID, idLevel ?? -1);

      for (var i = 0; i < data.length; i++) {
        Map<String, dynamic> map = data.elementAt(i);
        Map<String, dynamic> vocabIndividual =
            map[DatabaseConstants.tableVocabulary];

        String english = vocabIndividual[DatabaseConstants.english];
        String spanish = vocabIndividual[DatabaseConstants.spanish];

        Word word = Word.smart(
          spanish: spanish,
          english: english,
          category: Wordcategory.phrasalverb,
        );

        words.add(word);
      }
    } catch (e) {
      rethrow;
    }

    return words;
  }

  @override
  Future<void> saveOneWord(Word word) {
    // TODO: implement saveOneWord
    throw UnimplementedError();
  }

  @override
  Future<void> saveWords(List<Word> words) {
    // TODO: implement saveWords
    throw UnimplementedError();
  }
}
