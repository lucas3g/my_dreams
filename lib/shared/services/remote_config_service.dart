import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:injectable/injectable.dart';
import 'package:my_dreams/core/domain/entities/app_config.dart';
import 'package:my_dreams/core/domain/entities/subscription_plan.dart';

@singleton
class RemoteConfigService {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  Future<void> init() async {
    await _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(hours: 1),
      ),
    );

    await _remoteConfig.fetchAndActivate();

    final supabaseUrl = _remoteConfig.getString('SUPABASE_URL');
    if (supabaseUrl.isNotEmpty) {
      AppConfig.supabaseUrl = supabaseUrl;
    }

    final supabaseKey = _remoteConfig.getString('SUPABASE_ANON_KEY');
    if (supabaseKey.isNotEmpty) {
      AppConfig.supabaseAnonKey = supabaseKey;
    }

    final geminiKey = _remoteConfig.getString('GEMINI_API_KEY');
    if (geminiKey.isNotEmpty) {
      AppConfig.geminiApiKey = geminiKey;
    }

    final weeklyLimit = _remoteConfig.getInt('WEEKLY_PREMIUM_LIMIT');
    if (weeklyLimit > 0) {
      AppConfig.updateLimitForPlan(SubscriptionPlan.weekly, weeklyLimit);
    }

    final monthlyLimit = _remoteConfig.getInt('MONTHLY_PREMIUM_LIMIT');
    if (monthlyLimit > 0) {
      AppConfig.updateLimitForPlan(SubscriptionPlan.monthly, monthlyLimit);
    }

    final annualLimit = _remoteConfig.getInt('ANNUAL_PREMIUM_LIMIT');
    if (annualLimit > 0) {
      AppConfig.updateLimitForPlan(SubscriptionPlan.annual, annualLimit);
    }
  }
}
