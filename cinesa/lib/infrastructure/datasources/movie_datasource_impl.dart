import 'package:cinesa/config/env/app_env.dart';
import 'package:cinesa/domain/datasources/movies_datasource.dart';
import 'package:cinesa/domain/entities/movie.dart';
import 'package:cinesa/infrastructure/mappers/movie_mapper.dart';
import 'package:cinesa/infrastructure/models/moviedb/moviedb_response.dart';
import 'package:dio/dio.dart';

class MovieDBDatasourceImplementation extends MovieDatasoutce {
  final dio = Dio(
    BaseOptions(
      baseUrl: "https://api.themoviedb.org/3",
      queryParameters: {"api_key": AppEnv.keyTMDB, "language": "es-ES"},
    ),
  );

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
      List<Movie> movies = [];

      final response = await dio.get("/movie/now_playing");

      final movieDBResponse = MovieDbResponse.fromJson(response.data);

      movies = movieDBResponse.results
          .map((e) => MovieMapper.movieDbToEntity(e))
          .where((element) => element.posterPath != "no-poster")
          .toList();

      return movies;

  }
}
