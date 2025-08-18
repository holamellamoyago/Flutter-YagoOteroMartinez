import 'package:cinemapedia/domain/entities/movie.dart';

// Este es quien llama al datasource (movies_datasource)

abstract class MoviesRepository {
  Future<List<Movie>>getNowPlaying({int page = 1});
}
