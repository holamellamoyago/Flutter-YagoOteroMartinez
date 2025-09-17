import 'package:english_mvvm_provider_clean/data/datasources/file_words_datasource.dart';
import 'package:english_mvvm_provider_clean/data/repositories/local_word_repository_impl.dart';
import 'package:english_mvvm_provider_clean/data/view/save_word_widget.dart';
import 'package:english_mvvm_provider_clean/domain/usecases/get_words.dart';
import 'package:english_mvvm_provider_clean/data/viewmodel/words_viewmodel.dart';
import 'package:english_mvvm_provider_clean/domain/repositories/Words_repository.dart';
import 'package:english_mvvm_provider_clean/domain/usecases/save_word_usecase.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  final wordDatasource = FileWordsDatasource();
  final wordRepository = LocalWordRepositoryImpl(wordDatasource);
  final getWords = GetWords(wordRepository);
  final saveWords = SaveWordUsecase(wordRepository);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => WordsViewModel(getWords,saveWords)),
      ],
      child: MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(body: SaveWordWidget()),
    );
  }
}
