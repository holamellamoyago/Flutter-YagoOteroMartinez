import 'package:cinesa/config/env/app_env.dart';
import 'package:cinesa/domain/datasources/movies_datasource.dart';
import 'package:cinesa/domain/entities/movie.dart';
import 'package:cinesa/infrastructure/mappers/movie_mapper.dart';
import 'package:cinesa/infrastructure/models/moviedb/moviedb_details.dart';
import 'package:cinesa/infrastructure/models/moviedb/moviedb_response.dart';
import 'package:dio/dio.dart';

class MovieDBDatasourceImplementation extends MovieDatasoutce {
  final String regionEspanola = "ISO 3166-1";

  final dio = Dio(
    BaseOptions(
      baseUrl: "https://api.themoviedb.org/3",
      queryParameters: {"api_key": AppEnv.keyTMDB, "language": "es-ES"},
    ),
  );

  List<Movie> _jsonToMovies(Map<String, dynamic> map) {
    final movieDBResponse = MovieDbResponse.fromJson(map);

    return movieDBResponse.results
        .map((e) => MovieMapper.movieDbToEntity(e))
        .where((element) => element.posterPath != "")
        .where((element) => element.overview != "")
        .toList();
  }

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    final response = await dio.get(
      "/movie/now_playing",
      queryParameters: {"page": page},
    );

    return _jsonToMovies(response.data);
  }

  @override
  Future<List<Movie>> getPopular({page = 1}) async {
    final response = await dio.get(
      "/movie/popular",
      queryParameters: {"page": page, "region": regionEspanola},
    );

    return _jsonToMovies(response.data);
  }

  @override
  Future<List<Movie>> getUpComing({int page = 1}) async {
    final response = await dio.get(
      "/movie/upcoming",
      queryParameters: {"page": page},
    );

    return _jsonToMovies(response.data);
  }

  @override
  Future<List<Movie>> getTopRated({int page = 1}) async {
    final response = await dio.get(
      "/movie/top_rated",
      queryParameters: {"page": page, "region": regionEspanola},
    );

    return _jsonToMovies(response.data);
  }

  @override
  Future<Movie> getMovieById(String id) async {
    final response = await dio.get(
      "/movie/$id",
      queryParameters: {"language": "es-ES"},
    );

    if (response.statusCode != 200) throw Exception("Id not found");

    final movieDB = MovieDetails.fromJson(response.data);
    Movie movie = MovieMapper.movieDetailsDbToEntity(movieDB);

    return movie;
  }

  @override
  Future<List<Movie>> searchMovie(String query) async {
    if (query.isEmpty) return [];

    print("Realizando peticion");

    final response = await dio.get(
      "/search/movie",
      options: Options(responseType: ResponseType.json),
      queryParameters: {
        "language": "es-ES",
        "query": query,
        "include_adult": true,
        "region": regionEspanola,
      },
    );

    return _jsonToMovies(response.data);
  }
}
