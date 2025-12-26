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
}
