import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wispurr/data/datasources/remote_repository.dart';
import 'package:wispurr/domain/usecases/signup_usecase.dart';

import '../../../domain/entities/user_entity.dart';
import '../../../domain/usecases/get_all_users_usecase.dart';
import '../../../domain/usecases/get_current_user_usecase.dart';
import '../../../domain/usecases/login_usecase.dart';
import '../../../domain/usecases/logout_usecase.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final SignupUsecase signupUsecase;
  final LoginUsecase loginUsecase;
  final LogoutUsecase logoutUsecase;
  final GetCurrentUserUsecase getCurrentUserUsecase;
  final GetAllUsersUsecase getAllUsersUsecase;
  UserBloc({
    required this.signupUsecase,
    required this.loginUsecase,
    required this.logoutUsecase,
    required this.getCurrentUserUsecase,
    required this.getAllUsersUsecase,
  }) : super(UserInitial()) {
    on<LoginUser>(_onLogin);
    on<SignupUser>(_onSignup);
    on<LoadUserProfile>(_onLoadProfile);
    on<LogoutUser>(_onLogout);
  }

  Future<void> _onLogin(LoginUser event, Emitter<UserState> emit) async {
    emit(UserLoading());
    final success =
        await loginUsecase.call(email: event.email, password: event.password);

    if (success) {
      add(LoadUserProfile());
    } else {
      emit(const UserAuthFailed("Login failed"));
    }
  }

  Future<void> _onSignup(SignupUser event, Emitter<UserState> emit) async {
    emit(UserLoading());
    final success = await signupUsecase.call(
      username: event.username,
      email: event.email,
      password: event.password,
    );

    if (success) {
      add(LoadUserProfile());
    } else {
      emit(const UserAuthFailed("Signup failed"));
    }
  }

  Future<void> _onLoadProfile(
      LoadUserProfile event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final user = await getCurrentUserUsecase.call();
      emit(UserAuthenticated(user));
    } catch (e) {
      emit(const UserAuthFailed("Could not load profile"));
    }
  }

  Future<void> _onLogout(LogoutUser event, Emitter<UserState> emit) async {
    await logoutUsecase.call();
    emit(UserUnauthenticated());
  }
}
