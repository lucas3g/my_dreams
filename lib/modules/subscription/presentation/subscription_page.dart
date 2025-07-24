import 'package:flutter/material.dart';
import 'package:my_dreams/core/constants/constants.dart';
import 'package:my_dreams/core/di/dependency_injection.dart';
import 'package:my_dreams/shared/components/custom_button.dart';
import 'package:my_dreams/shared/services/purchase_service.dart';
import 'package:my_dreams/shared/themes/app_theme_constants.dart';
import 'package:my_dreams/shared/translate/translate.dart';

class SubscriptionPage extends StatelessWidget {
  const SubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final purchase = getIt<PurchaseService>();
    return Scaffold(
      appBar: AppBar(title: Text(translate('purchase.title'))),
      body: Padding(
        padding: const EdgeInsets.all(AppThemeConstants.mediumPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(),
            AppCustomButton(
              backgroundColor: context.myTheme.primary,
              expands: true,
              onPressed: () => purchase.buy(PurchaseService.weeklyId),
              label: Text(translate('purchase.weekly')),
            ),
            const SizedBox(height: 8),
            AppCustomButton(
              backgroundColor: context.myTheme.primary,
              expands: true,
              onPressed: () => purchase.buy(PurchaseService.monthlyId),
              label: Text(translate('purchase.monthly')),
            ),
            const SizedBox(height: 8),
            AppCustomButton(
              backgroundColor: context.myTheme.primary,
              expands: true,
              onPressed: () => purchase.buy(PurchaseService.annualId),
              label: Text(translate('purchase.annual')),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
