import 'package:english_mvvm_provider_clean/data/viewmodel/words_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListWordsWidget extends StatelessWidget {
  const ListWordsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WordsViewModel>();

    return Expanded(
      child: ListView.builder(
        itemCount: provider.words!.length,
        itemBuilder: (context, index) =>
            Text(provider.words!.elementAt(index).english),
      ),
    );
  }
}
