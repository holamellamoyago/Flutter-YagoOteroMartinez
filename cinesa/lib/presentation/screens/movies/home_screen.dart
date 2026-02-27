import 'package:cinesa/presentation/view/views.dart';
import 'package:flutter/material.dart';

import 'package:cinesa/presentation/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  static const name = "home-screen";
  final int pageIndex;

  const HomeScreen({super.key, required this.pageIndex});

  final viewRoutes = const <Widget> [HomeView(), SizedBox(), FavoritesView()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: pageIndex,
        children: viewRoutes,
      ),
      bottomNavigationBar: CustomBottomNavigattion(pageIndex: pageIndex,),
    );
  }
}
