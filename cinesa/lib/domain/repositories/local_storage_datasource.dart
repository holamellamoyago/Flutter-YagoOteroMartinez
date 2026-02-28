
import 'package:cinesa/domain/entities/movie.dart';

abstract class LocalStorageRepository {
  Future<void> toggleFavoriteMovie(Movie movie);
  Future<bool> isFavoriteMovie(int movie);
  
  Future<List<Movie>> loadFavoritesMovies({
    int limit = 10,
    int offset = 0
  });
}
