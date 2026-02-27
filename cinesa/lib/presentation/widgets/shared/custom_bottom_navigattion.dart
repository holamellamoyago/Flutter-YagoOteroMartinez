import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavigattion extends StatelessWidget {
  const CustomBottomNavigattion({super.key});

  int getCurrentIndex(BuildContext context) {
    final String location = GoRouterState.of(context).matchedLocation;

    switch (location) {
      case '/':
        return 0;
      case '/categories':
        return 1;
      case '/favorites':
        return 2;
      default:
        return 0;
    }
  }

  void onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        return context.go('/');
      case 1:
        return context.go('/');
      case 2:
        getCurrentIndex(context);
        return context.go('/favorites');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: getCurrentIndex(context),
      onTap: (value) => onItemTapped(context, value),
      items: [
        BottomNavigationBarItem(label: "Home", icon: Icon(Icons.home_max)),
        BottomNavigationBarItem(
          label: "Categories",
          icon: Icon(Icons.label_outline),
        ),
        BottomNavigationBarItem(
          label: "Favorites",
          icon: Icon(Icons.favorite_outline),
        ),
      ],
    );
  }
}
