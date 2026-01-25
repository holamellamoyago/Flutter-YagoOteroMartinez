import 'package:cinesa/domain/entities/movie.dart';
import 'package:cinesa/infrastructure/repositorie.dart/movie_repository_impl.dart';
import 'package:cinesa/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchedMoviesProvider =
    StateNotifierProvider<SearchedMoviesNotifier, List<Movie>>((ref) {
      final MovieRepositoryImpl movieRepository = ref.read(movieRepositoryProvider);

      return SearchedMoviesNotifier(
        ref: ref,
        searchedMovies: movieRepository.searchMovie,
      );
    });

typedef SearchedMoviesCallBack = Future<List<Movie>> Function(String query);

class SearchedMoviesNotifier extends StateNotifier<List<Movie>> {
  final SearchedMoviesCallBack searchedMovies;
  final Ref ref;

  SearchedMoviesNotifier({required this.ref, required this.searchedMovies})
    : super([]);

  Future<List<Movie>> searchedMoviesByQuery(String query) async {
    final List<Movie> movies = await searchedMovies(query);
    ref.read(searchQueryProvider.notifier).update((state) => query);

    state = movies;
    return movies;
  }
}
