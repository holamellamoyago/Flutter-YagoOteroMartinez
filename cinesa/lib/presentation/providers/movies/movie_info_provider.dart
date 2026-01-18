import 'package:cinesa/domain/entities/movie.dart';
import 'package:cinesa/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/legacy.dart';

final movieInfoProvider =
    StateNotifierProvider<MovieMapNotifier, Map<String, Movie>>((ref) {
      final GetMovieCallBack movie = ref
          .watch(movieRepositoryProvider)
          .getMovieById;

      return MovieMapNotifier(getMovie: movie);
    });

typedef GetMovieCallBack = Future<Movie> Function(String movieId);

class MovieMapNotifier extends StateNotifier<Map<String, Movie>> {
  final GetMovieCallBack getMovie;

  MovieMapNotifier({required this.getMovie}) : super({});

  Future<void> loadMovie(movieId) async {
    if (state[movieId] != null) return;

    print("Realizando peticion http");
    final movie = await getMovie(movieId);

    state.putIfAbsent(movieId, () => movie);
    state = {...state, movieId: movie};
  }
}
