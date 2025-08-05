import 'package:wispurr/data/datasources/remote_repository.dart';
import 'package:wispurr/domain/entities/user_entity.dart';
import 'package:wispurr/domain/repos/local_repository.dart';

class LocalRepositoryImpl implements LocalRepository {
  final RemoteRepository repo;

  LocalRepositoryImpl({required this.repo});

  @override
  Future<List<UserEntity>> getAllUsers() => repo.getAllUsers();

  @override
  Future<UserEntity> getProfile() => repo.getProfile();

  @override
  Future<bool> login({required String email, required String password}) =>
      repo.login(email: email, password: password);

  @override
  Future<void> logout() => repo.logout();

  @override
  Future<bool> signup(
          {required String username,
          required String email,
          required String password}) =>
      repo.signup(username: username, email: email, password: password);
}
