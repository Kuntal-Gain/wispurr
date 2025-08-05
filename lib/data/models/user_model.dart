import 'package:wispurr/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  final String id;
  final String username;
  final String email;
  final bool isOnline;
  final List<String> deviceTokens;
  final DateTime lastSeen;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.isOnline,
    required this.deviceTokens,
    required this.lastSeen,
    required this.createdAt,
    required this.updatedAt,
  }) : super(
          id: id,
          username: username,
          email: email,
          isOnline: isOnline,
          deviceTokens: deviceTokens,
          lastSeen: lastSeen,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'],
      username: json['username'],
      email: json['email'],
      isOnline: json['isOnline'],
      deviceTokens: List<String>.from(json['deviceTokens']),
      lastSeen: DateTime.parse(json['lastSeen']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'username': username,
      'email': email,
      'isOnline': isOnline,
      'deviceTokens': deviceTokens,
      'lastSeen': lastSeen.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
