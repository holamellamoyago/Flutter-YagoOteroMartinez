import 'package:cinesa/config/database/database.dart';
import 'package:cinesa/domain/datasources/local_storage_datasource.dart';
import 'package:cinesa/domain/entities/movie.dart';
import 'package:drift/drift.dart' as drift;

class DriftDatasourceImpl extends LocalStorageDatasource {
  final AppDatabase database;

  DriftDatasourceImpl(AppDatabase? databaseToUse)
    : database = databaseToUse ?? db;

  @override
  Future<bool> isFavoriteMovie(int movie) async {
    // Construir el Query
    final query = database.select(database.favoriteMovies)
      ..where((table) => table.movieId.equals(movie));

    // Ejecutar el Query
    final favoriteMovie = await query.getSingleOrNull();

    // Retornar el resultado
    return favoriteMovie != null;
  }

  @override
  Future<List<Movie>> loadFavoritesMovies({
    int limit = 10,
    int offset = 0,
  }) async {
    final query = database.select(database.favoriteMovies)
      ..limit(limit, offset: offset);

    final favoritesMoviesRows = await query.get();

    final List<Movie> movies = favoritesMoviesRows
        .map(
          (e) => Movie(
            adult: false,
            backdropPath: e.backdropPath,
            genreIds: const [],
            id: e.id,
            originalLanguage: "",
            originalTitle: e.originalTitle,
            overview: "",
            popularity: 0,
            posterPath: e.posterPath,
            title: e.title,
            video: false,
            voteAverage: e.voteAverage,
            voteCount: 0,
          ),
        )
        .toList();

    return movies;
  }

  @override
  Future<void> toggleFavoriteMovie(Movie movie) async {
    final isFavorite = await isFavoriteMovie(movie.id);

    if (isFavorite) {
      final deleteQuery = database.delete(database.favoriteMovies)
        ..where((tbl) => tbl.movieId.equals(movie.id));

      await deleteQuery.go();
    }

    await database
        .into(database.favoriteMovies)
        .insert(
          FavoriteMoviesCompanion.insert(
            movieId: movie.id,
            title: movie.title,
            originalTitle: movie.originalTitle,
            backdropPath: movie.backdropPath,
            posterPath: movie.posterPath,
            voteAverage: drift.Value(movie.voteAverage),
          ),
        );
  }
}
