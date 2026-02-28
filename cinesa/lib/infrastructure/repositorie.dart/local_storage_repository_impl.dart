import 'package:cinesa/domain/datasources/local_storage_datasource.dart';
import 'package:cinesa/domain/entities/movie.dart';
import 'package:cinesa/domain/repositories/local_storage_datasource.dart';

class LocalStorageRepositoryImpl extends LocalStorageRepository {
  final LocalStorageDatasource datasource;

  LocalStorageRepositoryImpl({required this.datasource});

  @override
  Future<bool> isFavoriteMovie(int movie) {
    return datasource.isFavoriteMovie(movie);
  }

  @override
  Future<List<Movie>> loadFavoritesMovies({int limit = 10, int offset = 0}) {
    return datasource.loadFavoritesMovies(limit: limit, offset: offset);
  }

  @override
  Future<void> toggleFavoriteMovie(Movie movie) {
    return datasource.toggleFavoriteMovie(movie);
  }
}
