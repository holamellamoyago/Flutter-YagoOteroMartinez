import 'package:cinesa/domain/entities/actor.dart';
import 'package:cinesa/presentation/providers/actors/actors_repository_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

final actorsByMovieProvier =
    StateNotifierProvider<ActorsByMovieNotifier, Map<String,List<Actor>>>((ref) {
      final GetActorsMovieCallBack getActorsMovieCallBack = ref
          .watch(actorRepositoryProvider)
          .getActorByMovie;

      return ActorsByMovieNotifier(getActors: getActorsMovieCallBack);
    });

typedef GetActorsMovieCallBack = Future<List<Actor>> Function(String movieId);

class ActorsByMovieNotifier extends StateNotifier<Map<String, List<Actor>>> {
  GetActorsMovieCallBack getActors;

  ActorsByMovieNotifier({required this.getActors}) : super({});

  Future<void> loadActors(String movieId) async {
    final List<Actor> actors = await getActors(movieId);

    state = {...state, movieId: actors};
  }
}
