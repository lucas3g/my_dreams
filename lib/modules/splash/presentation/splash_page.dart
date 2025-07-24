import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_dreams/core/domain/entities/app_global.dart';
import 'package:my_dreams/core/domain/entities/named_routes.dart';
import 'package:my_dreams/core/init/app_initializer.dart';
import 'package:my_dreams/shared/translate/translate.dart';

import 'splash_content.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool userIsLogged() {
    final AppGlobal appGlobal = AppGlobal.instance;

    return appGlobal.user != null;
  }

  Future<void> _init() async {
    await initializeAppDependencies();

    if (!mounted) return;

    if (userIsLogged()) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        NamedRoutes.home.route,
        (route) => false,
      );
    } else {
      Navigator.pushNamedAndRemoveUntil(
        context,
        NamedRoutes.auth.route,
        (route) => false,
      );
    }
  }

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light, // Para iOS
      ),
    );

    _init();
  }

  @override
  Widget build(BuildContext context) {
    return const SplashContent();
  }
}
