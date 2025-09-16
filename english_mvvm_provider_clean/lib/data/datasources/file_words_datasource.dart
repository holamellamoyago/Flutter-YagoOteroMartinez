import 'dart:io';

import 'package:english_mvvm_provider_clean/data/datasources/local_words_datasource.dart';
import 'package:english_mvvm_provider_clean/domain/entities/word.dart';

class FileWordsDatasource implements LocalWordsDatasource {
  
  List<Word> words = [];

  @override
  Future<List<Word>> getWords() {
    throw UnimplementedError();
  }
  
  @override
  Future<void> saveWords(List<Word> words) async {
    File file = File(".");
    
  }
}
