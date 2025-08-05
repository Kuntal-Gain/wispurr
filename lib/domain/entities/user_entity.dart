import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String username;
  final String email;
  final bool isOnline;
  final List<String> deviceTokens;
  final DateTime lastSeen;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserEntity({
    required this.id,
    required this.username,
    required this.email,
    required this.isOnline,
    required this.deviceTokens,
    required this.lastSeen,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        username,
        email,
        isOnline,
        deviceTokens,
        lastSeen,
        createdAt,
        updatedAt,
      ];
}
