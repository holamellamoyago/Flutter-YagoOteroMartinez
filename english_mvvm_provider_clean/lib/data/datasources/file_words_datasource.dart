import 'dart:convert';
import 'dart:io';

import 'package:english_mvvm_provider_clean/data/datasources/local_words_datasource.dart';
import 'package:english_mvvm_provider_clean/domain/entities/word.dart';
import 'package:english_mvvm_provider_clean/domain/enums/WordCategory.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;

class FileWordsDatasource implements LocalWordsDatasource {
  List<Word> words = [];

  @override
  Future<List<Word>> getWords() async {
    final filePath = await getLocalFilePath();
    final file = File(filePath);

    if (!await file.exists()) {
      var w = Word.smart(
        spanish: "no creado",
        english: "no creado",
        category: Wordcategory.noun
      );
      print("añadir w");
      return [w];
    }

    final jsonString = await file.readAsString();
    final List<dynamic> jsonList = jsonDecode(jsonString);

    return jsonList.map((json) => Word.fromJson(json)).toList();
  }

  @override
  Future<void> saveWords(List<Word> words) async {
    final file = File(await getLocalFilePath());
    final json = words.map((e) => e.toJson()).toList();
    final jsonString = jsonEncode(json);
    await file.writeAsString(jsonString);
  }

  @override
  Future<void> saveOneWord(Word word) async {
    final file = File(await getLocalFilePath());
    final json = word.toJson();
    final jsonString = jsonEncode(json);
    await file.writeAsString(jsonString);
  }

  Future<String> getLocalFilePath() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/words.json';

    // Copiar solo si no existe
    final file = File(path);
    if (!await file.exists()) {
      final data = await rootBundle.loadString('assets/files/words.json');
      await file.writeAsString(data);
    }
    return path;
  }
}
