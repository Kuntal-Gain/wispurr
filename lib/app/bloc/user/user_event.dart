part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class LoginUser extends UserEvent {
  final String email;
  final String password;

  const LoginUser({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class SignupUser extends UserEvent {
  final String username;
  final String email;
  final String password;

  const SignupUser({
    required this.username,
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [username, email, password];
}

class LoadUserProfile extends UserEvent {}

class LogoutUser extends UserEvent {}
