import 'package:wispurr/domain/entities/user_entity.dart';

abstract class RemoteRepository {
  Future<bool> login({required String email, required String password});
  Future<bool> signup({
    required String username,
    required String email,
    required String password,
  });
  Future<void> logout();
  Future<List<UserEntity>> getAllUsers();
  Future<UserEntity> getProfile();
}
