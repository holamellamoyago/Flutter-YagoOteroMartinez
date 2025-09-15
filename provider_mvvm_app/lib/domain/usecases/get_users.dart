import 'package:provider_mvvm_app/domain/entities/user.dart';
import 'package:provider_mvvm_app/domain/repositories/user_repository.dart';

class GetUsers {
  UserRepository userRepository;

  GetUsers(this.userRepository);

  Future<List<User>> call() {
    return userRepository.getUsers();
  }
}
