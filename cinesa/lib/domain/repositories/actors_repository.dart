import 'package:cinesa/domain/entities/actor.dart';

abstract class ActorsRepository {
  Future<List<Actor>> getActorByMovie(String movieId);
}
