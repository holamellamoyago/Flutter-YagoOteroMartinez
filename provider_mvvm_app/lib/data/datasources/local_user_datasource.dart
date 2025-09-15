import 'package:provider_mvvm_app/models/user.dart';

abstract class LocalUserDatasource {
  Future<List<User>> getUsers();
  Future<void> addUser(User user);
}

class InMemoryDatasource implements LocalUserDatasource {
  final List<User> _storage = [];

  @override
  Future<void> addUser(User user) async {
    _storage.add(user);
  }

  @override
  Future<List<User>> getUsers() async {
    User u1 = User("holamellamoyago");
    User u2 = User("pepe222");
    User u3 = User("menganito");

    _storage.add(u1);
    _storage.add(u2);
    _storage.add(u3);

    return List.unmodifiable(_storage);
  }
}
