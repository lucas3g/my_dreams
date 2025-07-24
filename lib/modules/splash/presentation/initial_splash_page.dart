import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_dreams/core/domain/entities/named_routes.dart';

import 'splash_content.dart';

class InitialSplashPage extends StatefulWidget {
  const InitialSplashPage({super.key});

  @override
  State<InitialSplashPage> createState() => _InitialSplashPageState();
}

class _InitialSplashPageState extends State<InitialSplashPage> {
  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
    );

    _loadDependencies();
  }

  Future<void> _loadDependencies() async {
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    Navigator.pushNamedAndRemoveUntil(
      context,
      NamedRoutes.splash.route,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return const SplashContent();
  }
}
