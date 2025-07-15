import 'package:injectable/injectable.dart';
import 'package:my_dreams/core/domain/entities/either_of.dart';
import 'package:my_dreams/core/domain/entities/failure.dart';
import 'package:my_dreams/core/domain/entities/usecase.dart';
import 'package:my_dreams/modules/auth/domain/entities/user_entity.dart';
import 'package:my_dreams/modules/auth/domain/repositories/auth_repository.dart';

@injectable
class LoginWithGoogleAccountUseCase implements UseCase<UserEntity, NoArgs> {
  final AuthRepository _authRepository;

  LoginWithGoogleAccountUseCase({required AuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  Future<EitherOf<AppFailure, UserEntity>> call(NoArgs args) async {
    return await _authRepository.loginWithGoogleAccount();
  }
}
