import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:my_dreams/core/domain/entities/usecase.dart';
import 'package:my_dreams/modules/auth/domain/usecases/login_with_google_account.dart';
import 'package:my_dreams/modules/auth/domain/usecases/logout_account.dart';
import 'package:my_dreams/modules/auth/presentation/controller/auth_events.dart';
import 'package:my_dreams/modules/auth/presentation/controller/auth_states.dart';

@injectable
class AuthBloc extends Bloc<AuthEvents, AuthStates> {
  final LoginWithGoogleAccountUseCase _loginWithGoogleAccountUseCase;
  final LogoutAccountUsecase _logoutAccountUsecase;

  AuthBloc({
    required LoginWithGoogleAccountUseCase loginWithGoogleAccountUseCase,
    required LogoutAccountUsecase logoutAccountUsecase,
  }) : _loginWithGoogleAccountUseCase = loginWithGoogleAccountUseCase,
       _logoutAccountUsecase = logoutAccountUsecase,
       super(AuthInitialState()) {
    on<LoginWithGoogleAccountEvent>(_onLoginWithGoogleAccount);
    on<LogoutAccountEvent>(_onLogoutAccount);
  }

  Future<void> _onLoginWithGoogleAccount(
    LoginWithGoogleAccountEvent event,
    Emitter<AuthStates> emit,
  ) async {
    emit(state.loading());

    final result = await _loginWithGoogleAccountUseCase(NoArgs());

    result.get(
      (failure) => emit(state.failure(failure.message)),
      (user) => emit(state.success(user)),
    );
  }

  Future<void> _onLogoutAccount(
    LogoutAccountEvent event,
    Emitter<AuthStates> emit,
  ) async {
    emit(state.loading());

    await Future.delayed(const Duration(seconds: 1));

    final result = await _logoutAccountUsecase(NoArgs());

    result.get(
      (failure) => emit(state.failure(failure.message)),
      (_) => emit(state.logout()),
    );
  }
}
