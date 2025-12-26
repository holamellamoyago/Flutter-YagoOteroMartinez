import 'package:cinesa/infrastructure/datasources/movie_datasource_impl.dart';
import 'package:cinesa/infrastructure/repositorie.dart/movie_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Este repositorio es de solo lectura
final movieRepositoryProvider = Provider((ref) {
  //TODO Probar si funciona con la abstract
  return MovieRepositoryImpl(datasource: MovieDBDatasourceImplementation());
});
