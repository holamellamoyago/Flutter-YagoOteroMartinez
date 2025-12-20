import 'package:english_mvvm_provider_clean/config/app_colors.dart';
import 'package:english_mvvm_provider_clean/data/strings/app_strings.dart';
import 'package:english_mvvm_provider_clean/data/viewmodel/levels_viewmodel.dart';
import 'package:english_mvvm_provider_clean/data/viewmodel/words_viewmodel.dart';
import 'package:english_mvvm_provider_clean/domain/entities/level.dart';
import 'package:english_mvvm_provider_clean/utils/snackbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LevelsScreen extends StatelessWidget {
  const LevelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    LevelsViewmodel levelProvider = Provider.of<LevelsViewmodel>(
      context,
      listen: true,
    );

    WordsViewModel wordProvider = Provider.of<WordsViewModel>(
      context,
      listen: true,
    );

    ScrollController controller = ScrollController();
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(title: Text("Levels"), centerTitle: true),
      body: levelProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Categories(
                  screenHeight: screenHeight,
                  provider: levelProvider,
                  controller: controller,
                ),
                SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    controller: controller,
                    itemCount: levelProvider.levels.length,
                    itemBuilder: (context, index) => LevelView(
                      wordProvider: wordProvider,
                      levelProvider: levelProvider,
                      index: index,
                      indexDatabsae: levelProvider.levels[index].id,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class LevelView extends StatelessWidget {
  const LevelView({
    super.key,
    required this.wordProvider,
    required this.levelProvider,
    required this.index,
    required this.indexDatabsae,
  });

  final WordsViewModel wordProvider;
  final LevelsViewmodel levelProvider;
  final int index;
  final int indexDatabsae;

  @override
  Widget build(BuildContext context) {
    final Level level = _loadLevel();
    final Color iconColor = levelProvider.isLevelCompleted(level.id)
        ? Colors.green
        : Colors.grey;

    return Card(
      color: Colors.white,
      elevation: 4,
      margin: EdgeInsets.all(8),
      child: ListTile(
        leading: Icon(Icons.school),
        trailing: Icon(Icons.check, color: iconColor),
        onTap: () async {
          print("index: " + index.toString());
          print("index databse " + indexDatabsae.toString());
          print("levelid" + level.id.toString());

          print(levelProvider.levels[index].name);

          print(levelProvider.levels.toString());

          await wordProvider.loadWords(level.id);

          // ignore: prefer_is_empty
          if (wordProvider.words == null || wordProvider.words?.length == 0) {
            print("No se cargaron las palabras");
          } else {
            print(wordProvider.words);
          }

          context.push(AppStrings.gameScreen);

          // if (context.mounted) {
          //   context.push(AppStrings.gameScreen);
          // }
        },
        title: Text(level.name),
        subtitle: Text(
          levelProvider.levels[index].description ?? "No hay descripción",
        ),
      ),
    );
  }

  Level _loadLevel() {
    return levelProvider.levels.firstWhere((e) => e.id == indexDatabsae);
  }
}

class Categories extends StatelessWidget {
  const Categories({
    super.key,
    required double screenHeight,
    required this.provider,
    required this.controller,
  }) : _screenHeight = screenHeight;

  final double _screenHeight;
  final LevelsViewmodel provider;
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: _screenHeight * 0.04,
      child: provider.categories.isEmpty
          ? Center(child: Text("No hay datos"))
          : ListView.builder(
              controller: controller,
              scrollDirection: Axis.horizontal,
              itemCount: provider.categories.length,
              itemBuilder: (context, i) => Padding(
                padding: const EdgeInsets.only(left: 8),
                child: GestureDetector(
                  onTap: () => provider.selected = provider.categories[i],
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: provider.selected == provider.categories[i]
                          ? AppColors.primaryColor
                          : Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        provider.categories[i].name,
                        style: TextStyle(
                          color: provider.selected != provider.categories[i]
                              ? Colors.grey
                              : null,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
