import 'dart:async';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:my_dreams/core/di/dependency_injection.config.dart';
import 'package:my_dreams/core/domain/entities/app_global.dart';
import 'package:my_dreams/core/domain/entities/usecase.dart';
import 'package:my_dreams/modules/auth/domain/usecases/auto_login.dart';
import 'package:my_dreams/shared/services/remote_config_service.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
Future<void> configureDependencies() async {
  _initAppGlobal();

  getIt.init();

  getIt.registerSingleton(RemoteConfigService());

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
