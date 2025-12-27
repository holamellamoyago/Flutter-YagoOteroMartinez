import 'package:flutter/material.dart';

import 'package:cinesa/presentation/providers/providers.dart';
import 'package:cinesa/presentation/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends StatelessWidget {
  static const name = "home-screen";

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _HomeView();
  }
}

class _HomeView extends ConsumerStatefulWidget {
  const _HomeView();

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<_HomeView> {
  @override
  void initState() {
    super.initState();

    // ref (notifier.loadNextPage())
    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    final moviesSlideshowProvider = ref.watch(moviesSlideShowProvider);

    return Scaffold(
      body: moviesSlideshowProvider.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                CustomAppbar(),
                MoviesSlideshow(movies: moviesSlideshowProvider)
                // Expanded(
                //   child: ListView.builder(
                //     itemCount: nowPlayingMovies.length,
                //     itemBuilder: (context, index) {
                //       Movie mov = nowPlayingMovies[index];
                //       return ListTile(title: Text(mov.title));
                //     },
                //   ),
                // ),
              ],
            ),
    );
  }
}
