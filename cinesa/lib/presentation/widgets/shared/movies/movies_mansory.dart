import 'package:cinesa/domain/entities/movie.dart';
import 'package:cinesa/presentation/widgets/shared/movies/movie_poster_link.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class MoviesMasory extends StatefulWidget {
  final List<Movie> movies;
  final Future<List<Movie>> Function()? loadNextPage;

  const MoviesMasory({super.key, required this.movies, this.loadNextPage});

  @override
  State<MoviesMasory> createState() => _MoviesMasoryState();
}

class _MoviesMasoryState extends State<MoviesMasory> {
  bool isLastPage = false;
  bool isLoadingPage = false;
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    scrollController.addListener(() {
      if (widget.loadNextPage == null) return;

      if (scrollController.position.pixels + 200 >=
          scrollController.position.maxScrollExtent) {
        loadNextPageMovies();
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void loadNextPageMovies() async {
    if (isLoadingPage || isLastPage) return;

    isLoadingPage = true;
    await widget.loadNextPage!();
    isLoadingPage = false;

    if (widget.movies.isEmpty) {
      isLastPage = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: MasonryGridView.count(
        controller: scrollController,
        itemCount: widget.movies.length,
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        itemBuilder: (context, index) {
          if (index == 1) {
            return Column(
              children: [
                SizedBox(height: 10),
                MoviePosterLink(movie: widget.movies[index]),
              ],
            );
          }

          return MoviePosterLink(movie: widget.movies[index]);
        },
      ),
    );
  }
}
