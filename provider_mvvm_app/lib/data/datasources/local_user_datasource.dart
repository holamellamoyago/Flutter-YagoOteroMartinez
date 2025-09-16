import 'package:provider_mvvm_app/domain/entities/user.dart';

abstract class LocalUserDatasource {
  Future<List<User>> getUsers();
  Future<void> addUser(User user);
}
