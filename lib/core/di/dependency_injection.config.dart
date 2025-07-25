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
import '../../modules/chat/data/datasources/chat_ai_datasource.dart' as _i883;
import '../../modules/chat/data/datasources/chat_ai_datasource_impl.dart'
    as _i514;
import '../../modules/chat/data/datasources/chat_datasource.dart' as _i335;
import '../../modules/chat/data/datasources/chat_datasource_impl.dart' as _i209;
import '../../modules/chat/data/repositories/chat_repository_impl.dart'
    as _i696;
import '../../modules/chat/domain/repositories/chat_repository.dart' as _i165;
import '../../modules/chat/domain/usecases/get_conversations.dart' as _i134;
import '../../modules/chat/domain/usecases/get_messages.dart' as _i312;
import '../../modules/chat/domain/usecases/parse_tarot_message.dart' as _i841;
import '../../modules/chat/domain/usecases/send_message.dart' as _i864;
import '../../modules/chat/presentation/controller/chat_bloc.dart' as _i307;
import '../../shared/services/ads_service.dart' as _i655;
import '../../shared/services/purchase_service.dart' as _i17;
import '../../shared/services/remote_config_service.dart' as _i662;
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
    gh.factory<_i841.ParseTarotMessageUseCase>(
      () => _i841.ParseTarotMessageUseCase(),
    );
    gh.singleton<_i655.AdsService>(() => _i655.AdsService());
    gh.singleton<_i17.PurchaseService>(() => _i17.PurchaseService());
    gh.singleton<_i662.RemoteConfigService>(() => _i662.RemoteConfigService());
    gh.singleton<_i86.ISupabaseClient>(() => _i788.SupabaseClientImpl());
    gh.factory<_i824.ILocalStorage>(() => _i755.SharedPreferencesService());
    gh.factory<_i123.GeminiClient>(
      () => _i123.GeminiClient(dio: gh<_i361.Dio>()),
    );
    gh.singleton<_i777.ClientHttp>(
      () => _i14.DioClientHttpImpl(dio: gh<_i361.Dio>()),
    );
    gh.factory<_i883.ChatAiDatasource>(
      () => _i514.ChatAiDatasourceImpl(client: gh<_i123.GeminiClient>()),
    );
    gh.factory<_i655.AuthDatasource>(
      () =>
          _i275.AuthDatasourceImpl(supabaseClient: gh<_i86.ISupabaseClient>()),
    );
    gh.factory<_i335.ChatDatasource>(
      () => _i209.ChatDatasourceImpl(
        supabaseClient: gh<_i86.ISupabaseClient>(),
        aiDatasource: gh<_i883.ChatAiDatasource>(),
      ),
    );
    gh.factory<_i779.AuthRepository>(
      () =>
          _i817.AuthRepositoryImpl(authDatasource: gh<_i655.AuthDatasource>()),
    );
    gh.factory<_i165.ChatRepository>(
      () => _i696.ChatRepositoryImpl(datasource: gh<_i335.ChatDatasource>()),
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
    gh.factory<_i134.GetConversationsUseCase>(
      () =>
          _i134.GetConversationsUseCase(repository: gh<_i165.ChatRepository>()),
    );
    gh.factory<_i312.GetMessagesUseCase>(
      () => _i312.GetMessagesUseCase(repository: gh<_i165.ChatRepository>()),
    );
    gh.factory<_i864.SendMessageUseCase>(
      () => _i864.SendMessageUseCase(repository: gh<_i165.ChatRepository>()),
    );
    gh.factory<_i307.ChatBloc>(
      () => _i307.ChatBloc(
        getConversationsUseCase: gh<_i134.GetConversationsUseCase>(),
        getMessagesUseCase: gh<_i312.GetMessagesUseCase>(),
        sendMessageUseCase: gh<_i864.SendMessageUseCase>(),
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
