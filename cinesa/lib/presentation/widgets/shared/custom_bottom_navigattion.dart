import 'package:flutter/material.dart';

class CustomBottomNavigattion extends StatelessWidget {
  const CustomBottomNavigattion({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(label: "Home", icon: Icon(Icons.home_max)),
        BottomNavigationBarItem(label: "Categories", icon: Icon(Icons.label_outline)),
        BottomNavigationBarItem(label: "Favorites", icon: Icon(Icons.favorite_outline)),
      ],
    );
  }
}
