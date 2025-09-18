import 'dart:convert';
import 'dart:io';

import 'package:english_mvvm_provider_clean/data/datasources/local_words_datasource.dart';
import 'package:english_mvvm_provider_clean/domain/entities/word.dart';

class FileWordsDatasource implements LocalWordsDatasource {
  List<Word> words = [];
  final String filePath = 'words.json';

  @override
  Future<List<Word>> getWords() async {
    final file = File(filePath);

    if (!await file.exists()) {
      return [];
    }

    final jsonString = await file.readAsString();
    final List<dynamic> jsonList = jsonDecode(jsonString);

    return jsonList.map((json) => Word.fromJson(json)).toList();
  }

  @override
  Future<void> saveWords(List<Word> words) async {
    final file = File(filePath);
    final json = words.map((e) => e.toJson()).toList();
    final jsonString = jsonEncode(json);
    await file.writeAsString(jsonString);
  }

  @override
  Future<void> saveOneWord(Word word) async {
    final file = File(filePath);
    final json = word.toJson();
    final jsonString = jsonEncode(json);
    await file.writeAsString(jsonString);
  }
}
