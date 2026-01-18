import 'package:cinesa/domain/datasources/actors_datasource.dart';
import 'package:cinesa/domain/entities/actor.dart';
import 'package:cinesa/domain/repositories/actors_repository.dart';

class ActorsRepositoryImpl extends ActorsRepository {
  final ActorsDatasource datasource;

  ActorsRepositoryImpl({required this.datasource});

  @override
  Future<List<Actor>> getActorByMovie(String movieId) {
    return datasource.getActorByMovie(movieId);
  }
}
