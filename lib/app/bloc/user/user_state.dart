part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserAuthenticated extends UserState {
  final UserEntity user;

  const UserAuthenticated(this.user);

  @override
  List<Object> get props => [user];
}

class UserUnauthenticated extends UserState {}

class UserAuthFailed extends UserState {
  final String message;

  const UserAuthFailed(this.message);

  @override
  List<Object> get props => [message];
}
