import 'package:my_dreams/modules/auth/domain/entities/user_entity.dart';

abstract class AuthDatasource {
  Future<UserEntity> loginWithGoogleAccount();
  Future<UserEntity?> autoLogin();
  Future<void> logout();
}
