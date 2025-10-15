import 'package:english_mvvm_provider_clean/data/datasources/database/database_datasource.dart';
import 'package:english_mvvm_provider_clean/domain/entities/app_user.dart';
import 'package:english_mvvm_provider_clean/domain/repositories/database_repository.dart';

class DatabaseRespositoryImpl extends DatabaseRepository {
  DatabaseDatasource datasource;
  DatabaseRespositoryImpl({required this.datasource});

  @override
  Future<List<AppUser>> getGeneralTable() {
    return datasource.getGeneralTable();
  }
  
  @override
  Future<void> saveUser(AppUser user) {
    return datasource.saveUser(user);
  }
}
