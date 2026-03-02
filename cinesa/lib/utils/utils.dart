import 'package:cinesa/domain/entities/movie.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Utils {
  static void moveToMovie(BuildContext context, Movie movie) {
    String location = GoRouterState.of(context).uri.path;
    location += '/movie/${movie.id}';
    print(location);
    context.push(location);
  }
}
