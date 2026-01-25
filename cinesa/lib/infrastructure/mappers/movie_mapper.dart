import 'package:cinesa/domain/entities/movie.dart';
import 'package:cinesa/infrastructure/models/moviedb/movie_moviedb.dart';
import 'package:cinesa/infrastructure/models/moviedb/moviedb_details.dart';

class MovieMapper {
  static String imageDefault =
      "https://upload.wikimedia.org/wikipedia/commons/a/a3/Image-not-found.png";

  static Movie movieDbToEntity(MovieFromMovieDB moviedb) => Movie(
    adult: moviedb.adult,
    backdropPath: (moviedb.backdropPath != "")
        ? "https://image.tmdb.org/t/p/w500${moviedb.backdropPath}"
        : imageDefault,
    genreIds: moviedb.genreIds.map((e) => e.toString()).toList(),
    id: moviedb.id,
    originalLanguage: moviedb.originalLanguage,
    originalTitle: moviedb.originalTitle,
    overview: moviedb.overview,
    popularity: moviedb.popularity,
    posterPath: (moviedb.posterPath != "")
        ? "https://image.tmdb.org/t/p/w500${moviedb.posterPath}"
        : imageDefault,
    // releaseDate: moviedb.releaseDate != null ? moviedb.releaseDate! : DateTime.now(),
    title: moviedb.title,
    video: moviedb.video,
    voteAverage: moviedb.voteAverage,
    voteCount: moviedb.voteCount,
  );

  static Movie movieDetailsDbToEntity(MovieDetails moviedb) => Movie(
    adult: moviedb.adult,
    backdropPath: moviedb.backdropPath,
    genreIds: moviedb.genres.map((e) => e.name.toString()).toList(),
    id: moviedb.id,
    originalLanguage: moviedb.originalLanguage,
    originalTitle: moviedb.originalTitle,
    overview: moviedb.overview,
    popularity: moviedb.popularity,
    posterPath: (moviedb.posterPath == '')
        ? imageDefault
        : "https://image.tmdb.org/t/p/w500${moviedb.posterPath}",
    // releaseDate: moviedb.releaseDate,
    title: moviedb.title,
    video: moviedb.video,
    voteAverage: moviedb.voteAverage,
    voteCount: moviedb.voteCount,
  );
}
