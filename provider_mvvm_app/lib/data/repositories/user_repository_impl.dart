import 'package:provider_mvvm_app/data/datasources/local_user_datasource.dart';
import 'package:provider_mvvm_app/domain/entities/user.dart';
import 'package:provider_mvvm_app/domain/repositories/user_repository.dart';

class UserRepositoryImplementation implements UserRepository {
  
  final LocalUserDatasource userDatasource;
  UserRepositoryImplementation(this.userDatasource);

  @override
  Future<List<User>> getUsers() async {
    return userDatasource.getUsers();
  }

  @override
  Future<void> addUser(User user) async {
    return userDatasource.addUser(user);
  }
}
