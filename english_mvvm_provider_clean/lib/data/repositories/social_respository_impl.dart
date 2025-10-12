import 'package:english_mvvm_provider_clean/data/datasources/social/social_datasource.dart';
import 'package:english_mvvm_provider_clean/domain/repositories/social_repository.dart';

class SocialRespositoryImpl extends SocialRepository {
  SocialDatasource datasource;
  SocialRespositoryImpl({required this.datasource});

  @override
  getGeneralTable() {
    datasource.getGeneralTable();
  }
}
