import 'package:cinesa/domain/entities/movie.dart';
import 'package:cinesa/presentation/providers/providers.dart';
import 'package:cinesa/presentation/widgets/shared/movies/movies_mansory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoritesView extends ConsumerStatefulWidget {
  const FavoritesView({super.key});

  @override
  ConsumerState<FavoritesView> createState() => _FavoritesView2State();
}

class _FavoritesView2State extends ConsumerState<FavoritesView> {
  @override
  void initState() {
    ref.read(favoriteMoviesProvider.notifier).loadNextPage();
    super.initState();
  }
  

  @override
  Widget build(BuildContext context) {
    final Map<int, Movie> favoritesProvider = ref.watch(favoriteMoviesProvider);
    final colorScheme = Theme.of(context).colorScheme;

    if (favoritesProvider.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border_outlined, color: colorScheme.primary),
            Text(
              'No hay películas',
              style: TextStyle(color: colorScheme.primary),
            ),
          ],
        ),
      );
    }

    return MoviesMasory(
      movies: favoritesProvider.values.toList(),
      loadNextPage: () =>
          ref.read(favoriteMoviesProvider.notifier).loadNextPage(),
    );
  }
}
