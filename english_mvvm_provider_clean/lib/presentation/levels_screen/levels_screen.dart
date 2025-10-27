import 'package:english_mvvm_provider_clean/config/app_colors.dart';
import 'package:english_mvvm_provider_clean/data/viewmodel/levels_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LevelsScreen extends StatelessWidget {
  const LevelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    LevelsViewmodel provider = Provider.of<LevelsViewmodel>(
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
                Text("Niveles"),
                SizedBox(
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
                              onTap: () =>
                                  provider.selected = provider.categories[i],
                              child: AnimatedContainer(
                                duration: Duration(seconds: 1),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color:
                                      provider.selected ==
                                          provider.categories[i]
                                      ? AppColors.primaryColor
                                      : Colors.white,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    provider.categories[i].name,
                                    style: TextStyle(
                                      color:
                                          provider.selected !=
                                              provider.categories[i]
                                          ? Colors.grey
                                          : null,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                ),
              ],
            ),
    );
  }
}
