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
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Email
            Row(
              children: [
                Expanded(child: TextField(controller: spanishController)),
                Expanded(child: TextField(controller: englishController)),
              ],
            ),

            FilledButton(
              onPressed: () async {
                var a = Word.smart(
                  spanish: "a",
                  english: "a",
                  category: Wordcategory.noun,
                );
                var b = Word.smart(
                  spanish: "a",
                  english: "c",
                  category: Wordcategory.noun,
                );
                var c = Word.smart(
                  spanish: "a",
                  english: "b",
                  category: Wordcategory.noun,
                );

                List<Word> l = [a, b, c];

                await wordProvider.savewords(l);
              },
              child: Text("Save ... Word"),
            ),
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
              child: Text("Guardar una word"),
            ),
          ],
        ),
      ),
    );
  }
}
