import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:cinesa/config/helpers/human_formats.dart';
import 'package:cinesa/domain/entities/movie.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

typedef SearchMovieCallBack = Future<List<Movie>> Function(String query);

class SearchMovieDelegate extends SearchDelegate<Movie?> {
  final SearchMovieCallBack searchMovies;
  List<Movie> initialMovies;

  SearchMovieDelegate({required this.searchMovies, required this.initialMovies})
    : super(
        searchFieldLabel: "Buscar película",
        autocorrect: true,
        enableSuggestions: true,
      );

  /*
    Esta función es muy interesante, el objetivo es no mandar a llamar a nuestra API,
    cada vez que modicamos el QUERY. 

    Entonces implementamos esta función que SI se llama cada vez que se modifica PERO 
    lo que hace es ejecutar una función despues de x tiempo que tu le configuras con 
    timer. La genialidad viene cuando esta función al llamarse cada vez que se modifica
    lo que hace es cancelar el timer y volver a empezar entonces nunca llega a la función
    de llamar a la API. 
  */

  StreamController<List<Movie>> debonceMovies = StreamController.broadcast();
  StreamController<bool> isLoadingStream = StreamController.broadcast();
  Timer? _debounceTimer;

  void clearStreams() {
    debonceMovies.close();
  }

  void _onQueryChange(String query) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      isLoadingStream.add(true);
      final List<Movie> movies = await searchMovies(query);
      debonceMovies.add(movies);
      initialMovies = movies;
      isLoadingStream.add(false);
    });
  }

  Widget buildResultSuggestions() {
    return StreamBuilder(
      initialData: initialMovies,
      stream: debonceMovies.stream,
      builder: (context, snapshot) {
        final movies = snapshot.data ?? [];
        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) {
            return _MovieItem(
              movie: movies[index],
              onMovieSelected: (context, movie) {
                clearStreams();
                close(context, movie);
              },
            );
          },
        );
      },
    );
  }

  @override
  String? get searchFieldLabel => "Buscar película";

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      StreamBuilder<bool>(
        stream: isLoadingStream.stream,
        builder: (context, snapshot) {
          final bool isLoading = snapshot.data ?? false;

          return isLoading
              ? SpinPerfect(
                  infinite: true,
                  animate: query.isNotEmpty,
                  child: IconButton(
                    onPressed: () => query = '',
                    icon: Icon(Icons.refresh),
                  ),
                )
              : FadeIn(
                  animate: query.isNotEmpty,
                  child: IconButton(
                    onPressed: () => query = '',
                    icon: Icon(Icons.close),
                  ),
                );
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        clearStreams();
        close(context, null);
      },
      icon: Icon(Icons.arrow_back_ios_new_outlined),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildResultSuggestions();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _onQueryChange(query);

    return buildResultSuggestions();
  }
}

class _MovieItem extends StatelessWidget {
  final Movie movie;
  final Function onMovieSelected;

  const _MovieItem({required this.movie, required this.onMovieSelected});

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () => onMovieSelected(context, movie),
      child: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 2.w, vertical: 4),
        child: Row(
          children: [
            // Image
            SizedBox(
              width: 20.w,
              child: ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(10),
                child: Image.network(
                  movie.posterPath,
                  loadingBuilder: (context, child, loadingProgress) =>
                      FadeIn(child: child),
                ),
              ),
            ),
            SizedBox(width: 4.w),
            // DEscripcion
            SizedBox(
              width: 70.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(movie.title, style: textStyles.titleMedium),

                  movie.overview.length > 100
                      ? Text("${movie.overview.substring(0, 100)}...")
                      : Text(movie.overview),
                  SizedBox(height: 1.h),
                  Row(
                    children: [
                      Icon(
                        Icons.star_half_outlined,
                        color: Colors.yellow.shade800,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        HumanFormats.number(movie.voteAverage, 1),
                        style: textStyles.bodyMedium!.copyWith(
                          color: Colors.yellow.shade900,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
