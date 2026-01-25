import 'package:cinesa/domain/datasources/movies_datasource.dart';
import 'package:cinesa/domain/entities/movie.dart';
import 'package:cinesa/domain/repositories/movies_repository.dart';

class MovieRepositoryImpl extends MoviesRepository {
  final MovieDatasoutce datasource;

  MovieRepositoryImpl({required this.datasource});

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) {
    return datasource.getNowPlaying(page: page);
  }

  @override
  Future<List<Movie>> getPopular({int page = 1}) {
    return datasource.getPopular(page: page);
  }

  @override
  Future<List<Movie>> getUpComing({int page = 1}) {
    return datasource.getUpComing(page: page);
  }

  @override
  Future<List<Movie>> getTopRated({int page = 1}) {
    return datasource.getTopRated(page: page);
  }

  @override
  Future<Movie> getMovieById(String id) {
    return datasource.getMovieById(id);
  }

  @override
  Future<List<Movie>> searchMovie(String query) {
    return datasource.searchMovie(query);
  }
}
