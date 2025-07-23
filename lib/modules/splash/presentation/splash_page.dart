import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_dreams/core/domain/entities/app_global.dart';
import 'package:my_dreams/core/domain/entities/app_assets.dart';
import 'package:my_dreams/core/domain/entities/named_routes.dart';
import 'package:my_dreams/shared/components/app_circular_indicator_widget.dart';
import 'package:my_dreams/core/constants/constants.dart';
import 'package:my_dreams/shared/translate/translate.dart';

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
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                AppAssets.logo,
                width: context.screenWidth * .5,
              ),
              const SizedBox(height: 20),
              Text(
                translate('splash.screen.title'),
                style: context.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              const AppCircularIndicatorWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
