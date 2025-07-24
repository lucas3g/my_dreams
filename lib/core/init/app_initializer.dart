import 'package:firebase_core/firebase_core.dart';
import 'package:my_dreams/core/di/dependency_injection.dart';
import 'package:my_dreams/core/domain/entities/app_config.dart';
import 'package:my_dreams/shared/services/ads_service.dart';
import 'package:my_dreams/shared/services/purchase_service.dart';
import 'package:my_dreams/shared/services/remote_config_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Handles the initialization of application dependencies.
Future<void> initializeAppDependencies() async {
  await Firebase.initializeApp();

  final RemoteConfigService remoteConfig = RemoteConfigService();
  await remoteConfig.init();

  await Supabase.initialize(
    url: AppConfig.supabaseUrl,
    anonKey: AppConfig.supabaseAnonKey,
  );

  await configureDependencies();

  final AdsService ads = getIt<AdsService>();
  await ads.init();

  final PurchaseService purchase = getIt<PurchaseService>();
  await purchase.init();
}
