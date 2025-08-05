import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:wispurr/app/bloc/user/user_bloc.dart';

import 'data/datasources/remote_repository.dart';
import 'data/datasources/remote_repository_impl.dart';
import 'data/repos/local_repository_impl.dart';
import 'domain/repos/local_repository.dart';
import 'domain/usecases/get_all_users_usecase.dart';
import 'domain/usecases/get_current_user_usecase.dart';
import 'domain/usecases/login_usecase.dart';
import 'domain/usecases/logout_usecase.dart';
import 'domain/usecases/signup_usecase.dart';
import 'utils/helpers/api_service.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // bloc
  sl.registerFactory<UserBloc>(
    () => UserBloc(
      signupUsecase: sl.call(),
      loginUsecase: sl.call(),
      logoutUsecase: sl.call(),
      getCurrentUserUsecase: sl.call(),
      getAllUsersUsecase: sl.call(),
    ),
  );

  // usecases
  sl.registerFactory<LoginUsecase>(() => LoginUsecase(repo: sl.call()));
  sl.registerFactory<SignupUsecase>(() => SignupUsecase(repo: sl.call()));
  sl.registerFactory<LogoutUsecase>(() => LogoutUsecase(repo: sl.call()));
  sl.registerFactory<GetCurrentUserUsecase>(
      () => GetCurrentUserUsecase(repo: sl.call()));
  sl.registerFactory<GetAllUsersUsecase>(
      () => GetAllUsersUsecase(repo: sl.call()));

  // repository
  sl.registerLazySingleton<RemoteRepository>(
      () => RemoteRepositoryImpl(apiService: sl.call()));
  sl.registerLazySingleton<LocalRepository>(
      () => LocalRepositoryImpl(repo: sl.call()));

  // externals
  sl.registerLazySingleton<ApiService>(() => ApiService());
  sl.registerLazySingleton<FlutterSecureStorage>(
      () => const FlutterSecureStorage());
}
