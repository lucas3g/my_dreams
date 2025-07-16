import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_dreams/core/domain/entities/app_global.dart';
import 'package:my_dreams/core/domain/entities/named_routes.dart';

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
    await Future.delayed(const Duration(seconds: 2));

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
    return Scaffold();
  }
}
