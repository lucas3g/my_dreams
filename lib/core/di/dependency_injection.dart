import 'dart:async';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:my_dreams/core/di/dependency_injection.config.dart';
import 'package:my_dreams/core/domain/entities/app_global.dart';
import 'package:my_dreams/core/domain/entities/usecase.dart';
import 'package:my_dreams/modules/auth/domain/usecases/auto_login.dart';
import 'package:my_dreams/core/data/clients/supabase/supabase_client_interface.dart';
import '../../core/data/clients/chatgpt/chat_gpt_client.dart';
import '../../modules/dream/data/datasources/chatgpt_datasource_impl.dart';
import '../../modules/dream/data/datasources/dream_datasource_impl.dart';
import '../../modules/dream/data/repositories/dream_repository_impl.dart';
import '../../modules/dream/domain/usecases/analyze_dream.dart';
import '../../modules/dream/domain/usecases/get_dreams.dart';
import '../../modules/dream/presentation/controller/dream_bloc.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
Future<void> configureDependencies() async {
  _initAppGlobal();

  await getIt.init();

  // Manual registrations for Dream feature
  getIt
    ..registerFactory(() => ChatGptClient(dio: getIt<Dio>()))
    ..registerFactory(() => ChatGptDatasourceImpl(client: getIt<ChatGptClient>()))
    ..registerFactory(() => DreamDatasourceImpl(supabaseClient: getIt<ISupabaseClient>()))
    ..registerFactory(() => DreamRepositoryImpl(
          datasource: getIt<DreamDatasourceImpl>(),
          chatGptDatasource: getIt<ChatGptDatasourceImpl>(),
        ))
    ..registerFactory(() => AnalyzeDreamUseCase(dreamRepository: getIt<DreamRepositoryImpl>()))
    ..registerFactory(() => GetDreamsUseCase(dreamRepository: getIt<DreamRepositoryImpl>()))
    ..registerFactory(() => DreamBloc(
          analyzeDreamUseCase: getIt<AnalyzeDreamUseCase>(),
          getDreamsUseCase: getIt<GetDreamsUseCase>(),
        ));

  await _tryAutoLogin();
}

@module
abstract class RegisterModule {
  // @preResolve
  // Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  Dio get dio => _dioFactory();
}

Dio _dioFactory() {
  final BaseOptions baseOptions = BaseOptions(
    headers: <String, dynamic>{'Content-Type': 'application/json'},
  );

  return Dio(baseOptions);
}

void _initAppGlobal() {
  AppGlobal(user: null);
}

Future<void> _tryAutoLogin() async {
  final AutoLoginUseCase autoLoginUsecase = getIt<AutoLoginUseCase>();

  await autoLoginUsecase(const NoArgs());
}
