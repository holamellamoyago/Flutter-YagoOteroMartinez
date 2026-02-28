import 'package:cinesa/infrastructure/datasources/drift_datasource_impl.dart';
import 'package:cinesa/infrastructure/repositorie.dart/local_storage_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final localStorageRepositoryProvider = Provider((ref) {
  return LocalStorageRepositoryImpl(datasource: DriftDatasourceImpl(null)); //Revisar que esto funcione. 
});    
