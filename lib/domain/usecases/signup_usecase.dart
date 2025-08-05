import '../repos/local_repository.dart';

class SignupUsecase {
  final LocalRepository repo;

  SignupUsecase({required this.repo});

  Future<bool> call({
    required String username,
    required String email,
    required String password,
  }) {
    return repo.signup(username: username, email: email, password: password);
  }
}
