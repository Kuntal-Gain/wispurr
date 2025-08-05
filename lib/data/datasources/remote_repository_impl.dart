import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wispurr/data/models/user_model.dart';
import 'package:wispurr/domain/entities/user_entity.dart';

import '../../utils/helpers/api_service.dart';
import 'remote_repository.dart';

class RemoteRepositoryImpl implements RemoteRepository {
  final ApiService apiService;

  RemoteRepositoryImpl({required this.apiService});

  @override
  Future<List<UserEntity>> getAllUsers() {
    // TODO: implement getAllUsers
    throw UnimplementedError();
  }

  @override
  Future<UserEntity> getProfile() async {
    try {
      final token = await apiService.getToken();

      final res = await apiService.get('auth/profile', headers: {
        'Authorization': 'Bearer $token',
      });

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);

        return UserModel.fromJson(data);
      } else {
        debugPrint(res.body);
        return UserModel(
          id: '',
          username: '',
          email: '',
          isOnline: false,
          deviceTokens: [],
          lastSeen: DateTime.now(),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
      }
    } catch (e) {
      debugPrint('Profile exception: $e');
      return UserModel(
        id: '',
        username: '',
        email: '',
        isOnline: false,
        deviceTokens: [],
        lastSeen: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }
  }

  @override
  Future<bool> login({required String email, required String password}) async {
    try {
      final res = await apiService.post('auth/login', body: {
        'email': email,
        'password': password,
      });

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);

        await apiService.setToken(data['token']);

        return true;
      } else {
        debugPrint(res.body);
        return false;
      }
    } catch (e) {
      debugPrint('Login exception: $e');
      return false;
    }
  }

  @override
  Future<void> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<bool> signup(
      {required String username,
      required String email,
      required String password}) async {
    try {
      final res = await apiService.post('auth/signup', body: {
        'username': username,
        'email': email,
        'password': password,
      });

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);

        await apiService.setToken(data['token']);

        return true;
      } else {
        debugPrint(res.body);
        return false;
      }
    } catch (e) {
      debugPrint('Signup exception: $e');
      return false;
    }
  }
}
