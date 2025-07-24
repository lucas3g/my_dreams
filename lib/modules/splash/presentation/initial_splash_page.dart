import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_dreams/core/init/app_initializer.dart';

import 'splash_content.dart';
import 'splash_page.dart';

class InitialSplashPage extends StatefulWidget {
  const InitialSplashPage({super.key});

  @override
  State<InitialSplashPage> createState() => _InitialSplashPageState();
}

class _InitialSplashPageState extends State<InitialSplashPage> {
  bool _showMainSplash = false;

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
    await initializeAppDependencies();

    if (!mounted) return;

    setState(() => _showMainSplash = true);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: _showMainSplash ? const SplashPage() : const SplashContent(),
    );
  }
}
