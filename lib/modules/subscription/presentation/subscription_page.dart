import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_dreams/core/di/dependency_injection.dart';
import 'package:my_dreams/core/domain/entities/app_global.dart';
import 'package:my_dreams/core/domain/entities/subscription_plan.dart';
import 'package:my_dreams/modules/subscription/domain/entities/purchase_state.dart';
import 'package:my_dreams/shared/components/app_circular_indicator_widget.dart';
import 'package:my_dreams/shared/components/app_snackbar.dart';
import 'package:my_dreams/shared/services/purchase_service.dart';
import 'package:my_dreams/shared/themes/app_theme_constants.dart';
import 'package:my_dreams/shared/translate/translate.dart';

import 'widgets/plan_card_widget.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({super.key});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  final PurchaseService _purchase = getIt<PurchaseService>();
  StreamSubscription<PurchaseState>? _subscription;
  PurchaseState _state = PurchaseState.idle;

  void _updatePlan() {
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _purchase.addListener(_updatePlan);
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
    _purchase.removeListener(_updatePlan);
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
            Text(
              translate(
                'purchase.current',
                params: {
                  'plan': translate('purchase.${AppGlobal.instance.plan.name}'),
                },
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            PlanCardWidget(
              title: translate('purchase.weekly'),
              price: _purchase.priceFor(PurchaseService.weeklyId).isNotEmpty
                  ? _purchase.priceFor(PurchaseService.weeklyId)
                  : translate('purchase.weeklyPrice'),
              benefits: [translate('purchase.weeklyBenefits')],
              isActive: AppGlobal.instance.plan == SubscriptionPlan.weekly,
              onTap: () => _purchase.buy(PurchaseService.weeklyId),
            ),
            const SizedBox(height: 8),
            PlanCardWidget(
              title: translate('purchase.monthly'),
              price: _purchase.priceFor(PurchaseService.monthlyId).isNotEmpty
                  ? _purchase.priceFor(PurchaseService.monthlyId)
                  : translate('purchase.monthlyPrice'),
              benefits: [translate('purchase.monthlyBenefits')],
              isActive: AppGlobal.instance.plan == SubscriptionPlan.monthly,
              onTap: () => _purchase.buy(PurchaseService.monthlyId),
            ),
            const SizedBox(height: 8),
            PlanCardWidget(
              title: translate('purchase.annual'),
              price: _purchase.priceFor(PurchaseService.annualId).isNotEmpty
                  ? _purchase.priceFor(PurchaseService.annualId)
                  : translate('purchase.annualPrice'),
              benefits: [translate('purchase.annualBenefits')],
              isActive: AppGlobal.instance.plan == SubscriptionPlan.annual,
              onTap: () => _purchase.buy(PurchaseService.annualId),
            ),
          ],
        ),
      ),
    );
  }
}
