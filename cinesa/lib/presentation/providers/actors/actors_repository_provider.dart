import 'package:cinesa/infrastructure/datasources/actors_datasource_impl.dart';
import 'package:cinesa/infrastructure/repositorie.dart/actors_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final actorRepositoryProvider = Provider(
  (ref) => ActorsRepositoryImpl(datasource: ActorsDatasourceImpl()),
);
