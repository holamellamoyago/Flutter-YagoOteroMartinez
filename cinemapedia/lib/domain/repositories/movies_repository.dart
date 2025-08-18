import 'package:cinemapedia/domain/entities/movie.dart';

// Este es quien llama al datasource (movies_datasource)

abstract class MovieRepository {
  Future<List<Movie>>getNowPlaying({int page = 1});
}
