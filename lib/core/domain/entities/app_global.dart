import 'package:my_dreams/modules/auth/domain/entities/user_entity.dart';

class AppGlobal {
  UserEntity? user;

  static late AppGlobal _instance;

  static AppGlobal get instance => _instance;

  factory AppGlobal({UserEntity? user}) {
    _instance = AppGlobal._internal(user);

    return _instance;
  }

  AppGlobal._internal(this.user);

  void setUser(UserEntity? userParam) => user = userParam;
}
