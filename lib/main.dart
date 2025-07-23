import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_dreams/app_widget.dart';
import 'package:my_dreams/core/constants/constants.dart';
import 'package:my_dreams/core/di/dependency_injection.dart';
import 'package:my_dreams/shared/services/ads_service.dart';
import 'package:my_dreams/shared/services/purchase_service.dart';
import 'package:my_dreams/shared/translate/translate.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(url: SUPABASE_URL, anonKey: SUPABASE_ANON_KEY);

  await Firebase.initializeApp();

  await configureDependencies();

  await I18nTranslate.create(
    loader: TranslateLoader(basePath: 'assets/i18n'),
  );

  final AdsService ads = getIt<AdsService>();
  await ads.init();
  final PurchaseService purchase = getIt<PurchaseService>();
  await purchase.init();

  runApp(const AppWidget());
}
