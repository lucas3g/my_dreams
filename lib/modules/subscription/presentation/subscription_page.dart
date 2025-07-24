import 'package:flutter/material.dart';
import 'package:my_dreams/core/constants/constants.dart';
import 'package:my_dreams/core/di/dependency_injection.dart';
import 'dart:async';

import 'package:my_dreams/shared/components/app_circular_indicator_widget.dart';
import 'package:my_dreams/shared/components/app_snackbar.dart';
import 'package:my_dreams/shared/components/custom_button.dart';
import 'package:my_dreams/shared/services/purchase_service.dart';
import 'package:my_dreams/modules/subscription/domain/entities/purchase_state.dart';
import 'package:my_dreams/shared/themes/app_theme_constants.dart';
import 'package:my_dreams/shared/translate/translate.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({super.key});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  final PurchaseService _purchase = getIt<PurchaseService>();
  StreamSubscription<PurchaseState>? _subscription;
  PurchaseState _state = PurchaseState.idle;

  @override
  void initState() {
    super.initState();
    _subscription = _purchase.stream.listen((state) {
      if (!mounted) return;
      setState(() => _state = state);

      if (state == PurchaseState.success) {
        showAppSnackbar(
          context,
          title: translate('purchase.title'),
          message: translate('purchase.success'),
          type: TypeSnack.success,
        );
      } else if (state == PurchaseState.error) {
        showAppSnackbar(
          context,
          title: translate('common.error'),
          message: translate('purchase.error'),
          type: TypeSnack.error,
        );
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(translate('purchase.title'))),
      body: Padding(
        padding: const EdgeInsets.all(AppThemeConstants.mediumPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_state == PurchaseState.loading)
              const Center(child: AppCircularIndicatorWidget()),
            const Spacer(),
            AppCustomButton(
              backgroundColor: context.myTheme.primary,
              expands: true,
              onPressed: _state == PurchaseState.loading
                  ? null
                  : () => _purchase.buy(PurchaseService.weeklyId),
              label: Text(translate('purchase.weekly')),
            ),
            const SizedBox(height: 8),
            AppCustomButton(
              backgroundColor: context.myTheme.primary,
              expands: true,
              onPressed: _state == PurchaseState.loading
                  ? null
                  : () => _purchase.buy(PurchaseService.monthlyId),
              label: Text(translate('purchase.monthly')),
            ),
            const SizedBox(height: 8),
            AppCustomButton(
              backgroundColor: context.myTheme.primary,
              expands: true,
              onPressed: _state == PurchaseState.loading
                  ? null
                  : () => _purchase.buy(PurchaseService.annualId),
              label: Text(translate('purchase.annual')),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
