import 'dart:async';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:my_dreams/core/di/dependency_injection.config.dart';
import 'package:my_dreams/core/domain/entities/app_global.dart';
import 'package:my_dreams/core/domain/entities/usecase.dart';
import 'package:my_dreams/modules/auth/domain/usecases/auto_login.dart';
import 'package:my_dreams/core/data/clients/supabase/supabase_client_interface.dart';
import 'package:my_dreams/modules/chat/data/datasources/chat_datasource.dart';
import 'package:my_dreams/modules/chat/data/datasources/chat_datasource_impl.dart';
import 'package:my_dreams/modules/chat/data/repositories/chat_repository_impl.dart';
import 'package:my_dreams/modules/chat/domain/repositories/chat_repository.dart';
import 'package:my_dreams/modules/chat/domain/usecases/get_conversations.dart';
import 'package:my_dreams/modules/chat/domain/usecases/get_messages.dart';
import 'package:my_dreams/modules/chat/domain/usecases/send_message.dart';
import 'package:my_dreams/modules/chat/presentation/controller/chat_bloc.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
Future<void> configureDependencies() async {
  _initAppGlobal();

  getIt.init();

  // Manual registration for chat module
  getIt
    ..registerFactory<ChatDatasource>(
        () => ChatDatasourceImpl(supabaseClient: getIt<ISupabaseClient>()))
    ..registerFactory<ChatRepository>(
        () => ChatRepositoryImpl(datasource: getIt<ChatDatasource>()))
    ..registerFactory<GetConversationsUseCase>(
        () => GetConversationsUseCase(repository: getIt<ChatRepository>()))
    ..registerFactory<GetMessagesUseCase>(
        () => GetMessagesUseCase(repository: getIt<ChatRepository>()))
    ..registerFactory<SendMessageUseCase>(
        () => SendMessageUseCase(repository: getIt<ChatRepository>()))
    ..registerFactory<ChatBloc>(() => ChatBloc(
          getConversationsUseCase: getIt<GetConversationsUseCase>(),
          getMessagesUseCase: getIt<GetMessagesUseCase>(),
          sendMessageUseCase: getIt<SendMessageUseCase>(),
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
