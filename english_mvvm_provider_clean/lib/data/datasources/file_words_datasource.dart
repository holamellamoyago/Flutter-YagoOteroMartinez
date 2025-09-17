import 'dart:convert';
import 'dart:io';

import 'package:english_mvvm_provider_clean/data/datasources/local_words_datasource.dart';
import 'package:english_mvvm_provider_clean/domain/entities/word.dart';

class FileWordsDatasource implements LocalWordsDatasource {
  List<Word> words = [];
  final String filePath = 'words.json';

  @override
  Future<List<Word>> getWords() {
    throw UnimplementedError();
  }

  @override
  Future<void> saveWords(List<Word> words) async {
    // TODO
  }

  @override
  Future<void> saveOneWord(Word word) async {
    final file = File(filePath);
    final json = word.toJson();
    final jsonString = jsonEncode(json);
    await file.writeAsString(jsonString);
  }
}
