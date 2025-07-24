import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:my_dreams/core/constants/constants.dart';
import 'package:my_dreams/core/domain/entities/app_assets.dart';
import 'package:my_dreams/shared/components/app_circular_indicator_widget.dart';
import 'package:my_dreams/shared/themes/app_theme_constants.dart';
import 'package:my_dreams/shared/translate/translate.dart';

class SplashContent extends StatelessWidget {
  const SplashContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppThemeConstants.mediumPadding),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(AppAssets.logo, width: context.screenWidth * .5),
                const SizedBox(height: 20),
                Text(
                  translate('splash.screen.title'),
                  style: context.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                const AppCircularIndicatorWidget().animate().fade(
                  duration: const Duration(milliseconds: 300),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
