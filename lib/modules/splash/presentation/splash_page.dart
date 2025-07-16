import 'package:flutter/material.dart';
import 'package:my_dreams/core/domain/entities/named_routes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  void _init() async {
    // Simulate a delay for splash screen
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    // Navigate to the next page, e.g., HomePage
    Navigator.pushReplacementNamed(context, NamedRoutes.auth.route);
  }

  @override
  void initState() {
    super.initState();

    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
