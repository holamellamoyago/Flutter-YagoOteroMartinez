// ignore_for_file: file_names

import 'package:animate_do/animate_do.dart';
import 'package:cinesa/domain/entities/actor.dart';
import 'package:cinesa/domain/entities/movie.dart';
import 'package:cinesa/presentation/providers/movies/movie_info_provider.dart';
import 'package:cinesa/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

class MovieScreen extends ConsumerStatefulWidget {
  static const name = "movie-screen";
  final String movieId;

  const MovieScreen({super.key, required this.movieId});

  @override
  ConsumerState createState() => _MovieScreenState();
}

class _MovieScreenState extends ConsumerState<MovieScreen> {
  @override
  void initState() {
    super.initState();

    ref.read(movieInfoProvider.notifier).loadMovie(widget.movieId);
    ref.read(actorsByMovieProvier.notifier).loadActors(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    final Movie? movie = ref.watch(movieInfoProvider)[widget.movieId];

    return Scaffold(
      body: movie == null
          ? Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                _CustomSliverAppBar(movie: movie),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _MovieDetails(movie: movie),
                    childCount: 1,
                  ),
                ),
              ],
            ),
    );
  }
}

class _MovieDetails extends StatelessWidget {
  final Movie movie;
  const _MovieDetails({required this.movie});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Aquí la foto , titulo , y descripción
        Padding(
          padding: EdgeInsetsGeometry.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(20),
                child: Image.network(movie.posterPath, width: 30.w),
              ),
              SizedBox(width: 1.w),
              SizedBox(
                width: 60.w,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(movie.title, style: textStyle.titleLarge),
                    SizedBox(height: 0.5.h),
                    Text(movie.overview),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Actores y más
        Padding(
          padding: EdgeInsetsGeometry.all(1.h),
          child: Wrap(
            children: [
              ...movie.genreIds.map(
                (e) => Container(
                  margin: EdgeInsets.only(right: 10),
                  child: Chip(
                    label: Text(e),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(20),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        _ActorsByMovie(movieId: movie.id.toString()),
      ],
    );
  }
}

class _CustomSliverAppBar extends StatelessWidget {
  final Movie movie;

  const _CustomSliverAppBar({required this.movie});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.black,
      expandedHeight: 70.h,
      foregroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        title: Text(
          movie.title,
          style: TextStyle(fontSize: 20, color: Colors.white),
          textAlign: TextAlign.start,
        ),
        background: Stack(
          children: [
            SizedBox.expand(
              child: Image.network(
                movie.posterPath,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress != null) {
                    return SizedBox();
                  } else {
                    return FadeIn(child: child);
                  }
                },
              ),
            ),
            SizedBox.expand(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.7, 1.0],
                    colors: [Colors.transparent, Colors.black87],
                  ),
                ),
              ),
            ),
            SizedBox.expand(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    stops: [0.0, 0.4],
                    colors: [Colors.black87, Colors.transparent],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActorsByMovie extends ConsumerWidget {
  final String movieId;
  const _ActorsByMovie({required this.movieId});

  @override
  Widget build(BuildContext context, ref) {
    final actorsByMovie = ref.watch(actorsByMovieProvier);

    if (actorsByMovie[movieId] == null) {
      return Center(child: CircularProgressIndicator());
    }

    final actors = actorsByMovie[movieId]!;

    return SizedBox(
      height: 24.h,
      child: ListView.builder(
        itemCount: actors.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          Actor actor = actors[index];
          return Container(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeInRight(
                  child: ClipRRect(
                    borderRadius: BorderRadiusGeometry.circular(20),
                    child: Image.network(
                      actor.profilePath,
                      height: 16.h,
                      width: 12.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 1.h),
                Text(actor.name, maxLines: 2),
                Text(
                  actor.character ?? "",
                  maxLines: 2,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.fade,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
