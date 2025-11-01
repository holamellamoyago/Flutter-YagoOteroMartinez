import 'package:english_mvvm_provider_clean/config/app_colors.dart';
import 'package:english_mvvm_provider_clean/data/viewmodel/levels_viewmodel.dart';
import 'package:english_mvvm_provider_clean/data/viewmodel/words_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class LevelsScreen extends StatelessWidget {
  const LevelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    LevelsViewmodel provider = Provider.of<LevelsViewmodel>(
      context,
      listen: true,
    );

    WordsViewModel wordProvider = Provider.of<WordsViewModel>(
      context,
      listen: true,
    );

    ScrollController controller = ScrollController();
    double _screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(title: Text("Levels"), centerTitle: true),
      body: provider.isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Categories(
                  screenHeight: _screenHeight,
                  provider: provider,
                  controller: controller,
                ),
                Expanded(
                  child: ListView.builder(
                    controller: controller,
                    itemCount: provider.levels.length,
                    itemBuilder: (context, index) => ListTile(
                      onTap: () async {
                        await wordProvider.loadWords(provider.levels[index].id);
                        if (context.mounted) {
                          // TODO Optimizar todo 
                          context.push("/game_screen");
                        }
                      },
                      title: Text(provider.levels[index].name),
                      subtitle: Text(
                        provider.levels[index].description ??
                            "No hay descripción",
                      ),
                    ),
                  ),
                ),
                FilledButton(
                  onPressed: () async {
                    print(wordProvider.words);
                  },
                  child: Text("Cargar"),
                ),
              ],
            ),
    );
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
