import 'package:flutter_ia/data/entities/contents.dart';
import 'package:flutter_ia/domain/datasources/ia_datasource.dart';
import 'package:flutter_ia/domain/repositories/ia_repository.dart';

class IARepositoryImpl extends IARepository {
  final IaDatasource datasource;

  IARepositoryImpl({required this.datasource});

  @override
  Future<String> sendMessage(Contents contents) async {
    return await datasource.sendMessage(contents);
  }
}
