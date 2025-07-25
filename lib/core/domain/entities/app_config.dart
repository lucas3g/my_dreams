import 'subscription_plan.dart';

class AppConfig {
  static String supabaseUrl = '';
  static String supabaseAnonKey = '';
  static String geminiApiKey = '';

  static final Map<SubscriptionPlan, int> _premiumLimits = {
    SubscriptionPlan.weekly: 5,
    SubscriptionPlan.monthly: 10,
    SubscriptionPlan.annual: 20,
  };

  static int limitForPlan(SubscriptionPlan plan) => _premiumLimits[plan] ?? 1;

  static void updateLimitForPlan(SubscriptionPlan plan, int limit) {
    if (limit > 0) {
      _premiumLimits[plan] = limit;
    }
  }
}
