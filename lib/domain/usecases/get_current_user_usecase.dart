import 'package:wispurr/domain/entities/user_entity.dart';

import '../repos/local_repository.dart';

class GetCurrentUserUsecase {
  final LocalRepository repo;

  GetCurrentUserUsecase({required this.repo});

  Future<UserEntity> call() {
    return repo.getProfile();
  }
}
