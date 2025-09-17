import 'package:english_mvvm_provider_clean/data/viewmodel/words_viewmodel.dart';
import 'package:english_mvvm_provider_clean/domain/entities/word.dart';
import 'package:english_mvvm_provider_clean/domain/enums/WordCategory.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SaveWordWidget extends StatelessWidget {
  const SaveWordWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final wordProvider = Provider.of<WordsViewModel>(context);
    TextEditingController spanishController = TextEditingController();
    TextEditingController englishController = TextEditingController();

    return Center(
      child: Column(
        children: [
          // Email
          TextField(controller: spanishController,),
          TextField(controller: englishController,),
          FilledButton(
            onPressed: () async {
              await wordProvider.saveOneWord(
                Word.smart(
                  spanish: spanishController.text,
                  english: englishController.text,
                  category: Wordcategory.noun,
                ),
              );
            },
            child: Text("Save Word"),
          ),
        ],
      ),
    );
  }
}
