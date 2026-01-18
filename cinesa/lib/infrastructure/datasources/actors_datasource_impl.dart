import 'package:cinesa/config/env/app_env.dart';
import 'package:cinesa/domain/datasources/actors_datasource.dart';
import 'package:cinesa/domain/entities/actor.dart';
import 'package:cinesa/infrastructure/mappers/actors_mappers.dart';
import 'package:cinesa/infrastructure/models/moviedb/credits_response.dart';
import 'package:dio/dio.dart';

class ActorsDatasourceImpl extends ActorsDatasource {
  final String regionEspanola = "ISO 3166-1";

  final dio = Dio(
    BaseOptions(
      baseUrl: "https://api.themoviedb.org/3/movie/",
      queryParameters: {
        "api_key": AppEnv.keyTMDB,
        "language": "es-ES",
      },
    ),
  );

  @override
  Future<List<Actor>> getActorByMovie(String movieId) async {
    final response = await dio.get("$movieId/credits");

    List<Actor> actors = CreditsReponse.fromJson(
      response.data,
    ).cast.map((e) => ActorsMappers.castToEntity(e)).toList();

    return actors;
  }
}
