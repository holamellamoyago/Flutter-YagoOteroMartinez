import 'package:cinesa/domain/entities/movie.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Utils {
  static void moveToMovie(BuildContext context, Movie movie) {
    final String location = GoRouterState.of(context).path ?? 'no path';
    context.push('$location/movie/${movie.id}');
  }
}
