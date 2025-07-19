// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../modules/auth/data/datasources/auth_datasource.dart' as _i655;
import '../../modules/auth/data/datasources/auth_datasource_impl.dart' as _i275;
import '../../modules/auth/data/repositories/auth_repository_impl.dart'
    as _i817;
import '../../modules/auth/domain/repositories/auth_repository.dart' as _i779;
import '../../modules/auth/domain/usecases/auto_login.dart' as _i51;
import '../../modules/auth/domain/usecases/login_with_google_account.dart'
    as _i854;
import '../../modules/auth/domain/usecases/logout_account.dart' as _i720;
import '../../modules/auth/presentation/controller/auth_bloc.dart' as _i311;
import '../../modules/dream/data/datasources/dream_datasource.dart' as _i735;
import '../../modules/dream/data/datasources/dream_datasource_impl.dart'
    as _i866;
import '../../modules/dream/data/datasources/gemini_datasource.dart' as _i163;
import '../../modules/dream/data/datasources/gemini_datasource_impl.dart'
    as _i619;
import '../../modules/dream/data/repositories/dream_repository_impl.dart'
    as _i648;
import '../../modules/dream/domain/repositories/dream_repository.dart' as _i563;
import '../../modules/dream/domain/usecases/analyze_dream.dart' as _i357;
import '../../modules/dream/domain/usecases/generate_dream_image.dart' as _i708;
import '../../modules/dream/domain/usecases/get_dreams.dart' as _i1037;
import '../../modules/dream/presentation/controller/dream_bloc.dart' as _i933;
import '../data/clients/gemini/gemini_client.dart' as _i123;
import '../data/clients/http/client_http.dart' as _i777;
import '../data/clients/http/dio_http_client_impl.dart' as _i14;
import '../data/clients/shared_preferences/local_storage_interface.dart'
    as _i824;
import '../data/clients/shared_preferences/shared_preferences_service.dart'
    as _i755;
import '../data/clients/supabase/supabase_client_impl.dart' as _i788;
import '../data/clients/supabase/supabase_client_interface.dart' as _i86;
import 'dependency_injection.dart' as _i9;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.factory<_i361.Dio>(() => registerModule.dio);
    gh.singleton<_i86.ISupabaseClient>(() => _i788.SupabaseClientImpl());
    gh.factory<_i824.ILocalStorage>(() => _i755.SharedPreferencesService());
    gh.factory<_i123.GeminiClient>(
      () => _i123.GeminiClient(dio: gh<_i361.Dio>()),
    );
    gh.factory<_i163.GeminiDatasource>(
      () => _i619.GeminiDatasourceImpl(client: gh<_i123.GeminiClient>()),
    );
    gh.singleton<_i777.ClientHttp>(
      () => _i14.DioClientHttpImpl(dio: gh<_i361.Dio>()),
    );
    gh.factory<_i735.DreamDatasource>(
      () =>
          _i866.DreamDatasourceImpl(supabaseClient: gh<_i86.ISupabaseClient>()),
    );
    gh.factory<_i563.DreamRepository>(
      () => _i648.DreamRepositoryImpl(
        datasource: gh<_i735.DreamDatasource>(),
        geminiDatasource: gh<_i163.GeminiDatasource>(),
      ),
    );
    gh.factory<_i655.AuthDatasource>(
      () =>
          _i275.AuthDatasourceImpl(supabaseClient: gh<_i86.ISupabaseClient>()),
    );
    gh.factory<_i357.AnalyzeDreamUseCase>(
      () => _i357.AnalyzeDreamUseCase(
        dreamRepository: gh<_i563.DreamRepository>(),
      ),
    );
    gh.factory<_i708.GenerateDreamImageUseCase>(
      () => _i708.GenerateDreamImageUseCase(
        dreamRepository: gh<_i563.DreamRepository>(),
      ),
    );
    gh.factory<_i1037.GetDreamsUseCase>(
      () =>
          _i1037.GetDreamsUseCase(dreamRepository: gh<_i563.DreamRepository>()),
    );
    gh.factory<_i933.DreamBloc>(
      () => _i933.DreamBloc(
        analyzeDreamUseCase: gh<_i357.AnalyzeDreamUseCase>(),
        getDreamsUseCase: gh<_i1037.GetDreamsUseCase>(),
      ),
    );
    gh.factory<_i779.AuthRepository>(
      () =>
          _i817.AuthRepositoryImpl(authDatasource: gh<_i655.AuthDatasource>()),
    );
    gh.factory<_i51.AutoLoginUseCase>(
      () => _i51.AutoLoginUseCase(authRepository: gh<_i779.AuthRepository>()),
    );
    gh.factory<_i854.LoginWithGoogleAccountUseCase>(
      () => _i854.LoginWithGoogleAccountUseCase(
        authRepository: gh<_i779.AuthRepository>(),
      ),
    );
    gh.factory<_i720.LogoutAccountUsecase>(
      () => _i720.LogoutAccountUsecase(
        authRepository: gh<_i779.AuthRepository>(),
      ),
    );
    gh.factory<_i311.AuthBloc>(
      () => _i311.AuthBloc(
        loginWithGoogleAccountUseCase:
            gh<_i854.LoginWithGoogleAccountUseCase>(),
        logoutAccountUsecase: gh<_i720.LogoutAccountUsecase>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i9.RegisterModule {}
