import '../repos/local_repository.dart';

class LogoutUsecase {
  final LocalRepository repo;

  LogoutUsecase({required this.repo});

  Future<void> call() {
    return repo.logout();
  }
}
