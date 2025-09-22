import 'package:english_mvvm_provider_clean/config/app_shadows.dart';
import 'package:english_mvvm_provider_clean/data/viewmodel/bottombar_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainHomeScreen extends StatelessWidget {
  const MainHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    BottombarViewmodel provider = Provider.of<BottombarViewmodel>(context);
    final primaryColor = Theme.of(context).colorScheme.primary;

    final IconThemeData unselectedIconThemeData = IconThemeData(
      color: Colors.grey,
      shadows: [AppShadows.shadow],
    );

    final IconThemeData selectedIconThemeData = IconThemeData(
      shadows: [AppShadows.shadow],

      color: primaryColor,
    );

    return Scaffold(
      body: provider.screens.elementAt(provider.selectedIndex),
      bottomNavigationBar: Container(
        color: primaryColor,
        child: ClipRRect(
          borderRadius: BorderRadiusGeometry.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.white,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            selectedIconTheme: selectedIconThemeData,
            unselectedIconTheme: unselectedIconThemeData,
            selectedLabelStyle: TextStyle(color: primaryColor),
            unselectedLabelStyle: TextStyle(color: Colors.grey),
            selectedItemColor: primaryColor,
            unselectedItemColor: Colors.grey,
            selectedFontSize: 16,
            unselectedFontSize: 12,
            items: provider.lista,
            currentIndex: provider.selectedIndex,
            type: BottomNavigationBarType.fixed,

            onTap: (value) {
              provider.changeScreen(value);
            },
          ),
        ),
      ),
    );
  }
}
