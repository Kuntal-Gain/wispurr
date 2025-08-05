import 'package:wispurr/domain/entities/user_entity.dart';
import 'package:wispurr/domain/repos/local_repository.dart';

class GetAllUsersUsecase {
  final LocalRepository repo;

  GetAllUsersUsecase({required this.repo});

  Future<List<UserEntity>> call() {
    return repo.getAllUsers();
  }
}
