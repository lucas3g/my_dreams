import 'package:flutter/material.dart';
import 'package:my_dreams/core/constants/constants.dart';
import 'package:my_dreams/core/di/dependency_injection.dart';
import 'package:my_dreams/shared/components/custom_button.dart';
import 'package:my_dreams/shared/services/purchase_service.dart';
import 'package:my_dreams/shared/themes/app_theme_constants.dart';
import 'package:my_dreams/shared/translate/translate.dart';

class SubscriptionBottomSheet extends StatelessWidget {
  const SubscriptionBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: context.myTheme.primaryContainer,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppThemeConstants.mediumBorderRadius),
        ),
      ),
      builder: (_) => const SubscriptionBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final purchase = getIt<PurchaseService>();

    return Padding(
      padding: const EdgeInsets.all(AppThemeConstants.mediumPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            translate('purchase.title'),
            style: context.textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          AppCustomButton(
            backgroundColor: context.myTheme.primary,
            expands: true,
            onPressed: () {
              Navigator.pop(context);
              purchase.buy(PurchaseService.weeklyId);
            },
            label: Text(translate('purchase.weekly')),
          ),
          const SizedBox(height: 8),
          AppCustomButton(
            backgroundColor: context.myTheme.primary,
            expands: true,
            onPressed: () {
              Navigator.pop(context);
              purchase.buy(PurchaseService.monthlyId);
            },
            label: Text(translate('purchase.monthly')),
          ),
          const SizedBox(height: 8),
          AppCustomButton(
            backgroundColor: context.myTheme.primary,
            expands: true,
            onPressed: () {
              Navigator.pop(context);
              purchase.buy(PurchaseService.annualId);
            },
            label: Text(translate('purchase.annual')),
          ),
        ],
      ),
    );
  }
}
