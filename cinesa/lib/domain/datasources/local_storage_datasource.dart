import 'package:cinesa/domain/entities/movie.dart';

abstract class LocalStorageDatasource {
  Future<void> toggleFavoriteMovie(Movie movie);
  Future<bool> isFavoriteMovie(int movieId);

  Future<List<Movie>> loadFavoritesMovies({int limit = 10, int offset = 0});
}
