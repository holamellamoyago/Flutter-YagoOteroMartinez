import 'package:cinesa/domain/entities/movie.dart';

abstract class MovieDatasoutce {
  Future<List<Movie>> getNowPlaying({int page = 1});
}
