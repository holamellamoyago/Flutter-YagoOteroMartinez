import 'package:cinesa/presentation/providers/movies/movies_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final initialLoadingProvider = Provider<bool>((ref) {
  final pro1 = ref.watch(nowPlayingMoviesProvider).isEmpty;
  final pro2 = ref.watch(popularMoviesProvider).isEmpty;
  final pro3 = ref.watch(upComingMoviesProvider).isEmpty;
  final pro4 = ref.watch(topRatedMoviesProvider).isEmpty;

  if (pro1 || pro2 || pro3 || pro4) {
    return true;
  }

  return false;
});
