import 'package:provider_mvvm_app/data/datasources/local_user_datasource.dart';
import 'package:provider_mvvm_app/models/user.dart';

abstract class UserRepository {
  Future<List<User>> getUsers();
  Future<void> addUser(User user);
}

class UserRepositoryImplementation implements UserRepository {
  
  final LocalUserDatasource localUserDatasource;
  UserRepositoryImplementation(this.localUserDatasource);

  @override
  Future<List<User>> getUsers() async {
    return localUserDatasource.getUsers();
  }

  @override
  Future<void> addUser(User user) async {
    return localUserDatasource.addUser(user);
  }
}
