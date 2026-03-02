import 'package:cinesa/domain/entities/movie.dart';
import 'package:cinesa/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MoviePosterLink extends StatelessWidget {
  final Movie movie;
  const MoviePosterLink({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Utils.moveToMovie(context, movie);
        print(movie.id.toString() +  " " + movie.title.toString());
      },

      // onTap: () => context.push('/home/0/movie/${movie.id}'),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.network(movie.posterPath),
      ),
    );
  }
}
