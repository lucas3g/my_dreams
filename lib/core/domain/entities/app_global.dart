import 'package:my_dreams/modules/auth/domain/entities/user_entity.dart';
import 'subscription_plan.dart';

class AppGlobal {
  UserEntity? user;
  SubscriptionPlan plan;

  static late AppGlobal _instance;

  static AppGlobal get instance => _instance;

  factory AppGlobal({UserEntity? user, SubscriptionPlan plan = SubscriptionPlan.free}) {
    _instance = AppGlobal._internal(user, plan);

    return _instance;
  }

  AppGlobal._internal(this.user, this.plan);

  void setUser(UserEntity? userParam) => user = userParam;
  void setPlan(SubscriptionPlan planParam) => plan = planParam;
  bool get isPremium => plan != SubscriptionPlan.free;
}
