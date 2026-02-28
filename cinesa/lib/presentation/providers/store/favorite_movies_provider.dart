import 'package:cinesa/domain/entities/movie.dart';
import 'package:cinesa/domain/repositories/local_storage_datasource.dart';
import 'package:cinesa/presentation/providers/store/local_storage_provider.dart';
import 'package:flutter_riverpod/legacy.dart';

final favoriteMoviesProvider = StateNotifierProvider((ref) {
  final localStorageRepository = ref.watch(localStorageRepositoryProvider);

  return StorageMoviesNotifier(localStorageRepository: localStorageRepository);
});

class StorageMoviesNotifier extends StateNotifier<Map<int, Movie>> {
  int page = 0;
  final LocalStorageRepository localStorageRepository;

  StorageMoviesNotifier({required this.localStorageRepository}) : super({});

  Future<void> toggleFavoriteMovie(Movie movie) async {
    final isFavorite = await localStorageRepository.isFavoriteMovie(movie.id);

    await localStorageRepository.toggleFavoriteMovie(movie);

    if (isFavorite) {
      state.remove(movie.id);
      state = {...state};
      return;
    }

    state = {...state, movie.id: movie};
  }
}
