import '../repos/local_repository.dart';

class LoginUsecase {
  final LocalRepository repo;

  LoginUsecase({required this.repo});

  Future<bool> call({required String email, required String password}) {
    return repo.login(email: email, password: password);
  }
}
