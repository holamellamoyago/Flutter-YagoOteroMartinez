
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

import 'package:cinesa/presentation/providers/providers.dart';
import 'package:cinesa/presentation/widgets/widgets.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends ConsumerState<HomeView> {
  @override
  void initState() {
    super.initState();

    // ref (notifier.loadNextPage())
    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
    ref.read(popularMoviesProvider.notifier).loadNextPage();
    ref.read(upComingMoviesProvider.notifier).loadNextPage();
    ref.read(topRatedMoviesProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    final initialLoading = ref.watch(initialLoadingProvider);

    final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);
    final popularMovies = ref.watch(popularMoviesProvider);
    final upComingMovies = ref.watch(upComingMoviesProvider);
    final topRatedMovies = ref.watch(topRatedMoviesProvider);
    final moviesSlideshowProvider = ref.watch(moviesSlideShowProvider);

    return initialLoading
        ? FullScreenLoader()
        // Lo que hace este widget es quitar la visibilidad para que se vayan cargando las imagenes pero en cambio no se mire el widget
        : Visibility(
            visible: !initialLoading,
            child: CustomScrollView(
              slivers: [
                SliverAppBar(floating: true, flexibleSpace: CustomAppbar()),
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return Column(
                      children: [
                        MoviesSlideshow(movies: moviesSlideshowProvider),
                        MovieHorizontalListview(
                          movies: nowPlayingMovies,
                          title: "En cines",
                          subtitle: "Sábado 27",
                          loadNextPage: () {
                            ref
                                .read(nowPlayingMoviesProvider.notifier)
                                .loadNextPage();
                          },
                        ),
                        // Proximamente
                        MovieHorizontalListview(
                          movies: upComingMovies,
                          title: "Proximamente",
                          loadNextPage: () {
                            ref
                                .read(upComingMoviesProvider.notifier)
                                .loadNextPage();
                          },
                        ),
                        // Peliculas populares
                        MovieHorizontalListview(
                          movies: popularMovies,
                          title: "Populares",
                          subtitle: "En este mes",
                          loadNextPage: () {
                            ref
                                .read(popularMoviesProvider.notifier)
                                .loadNextPage();
                          },
                        ),
                        MovieHorizontalListview(
                          movies: topRatedMovies,
                          title: "Mejor calificadas",
                          subtitle: "Desde siempre",
                          loadNextPage: () {
                            ref
                                .read(topRatedMoviesProvider.notifier)
                                .loadNextPage();
                          },
                        ),
                        SizedBox(height: 8.h),
                      ],
                    );
                  }, childCount: 1),
                ),
              ],
            ),
          );
  }
}
