import 'dart:async';

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:injectable/injectable.dart';
import 'package:my_dreams/core/domain/entities/app_global.dart';
import 'package:my_dreams/core/domain/entities/subscription_plan.dart';

@injectable
class PurchaseService {
  final InAppPurchase _iap = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  static const String weeklyId = 'weekly_plan';
  static const String monthlyId = 'monthly_plan';
  static const String annualId = 'annual_plan';

  Future<void> init() async {
    final bool available = await _iap.isAvailable();
    if (!available) return;
    _subscription = _iap.purchaseStream.listen(_onPurchaseUpdated);
    await _iap.restorePurchases();
  }

  void _onPurchaseUpdated(List<PurchaseDetails> purchases) {
    for (final purchase in purchases) {
      if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        if (purchase.productID == weeklyId) {
          AppGlobal.instance.setPlan(SubscriptionPlan.weekly);
        } else if (purchase.productID == monthlyId) {
          AppGlobal.instance.setPlan(SubscriptionPlan.monthly);
        } else if (purchase.productID == annualId) {
          AppGlobal.instance.setPlan(SubscriptionPlan.annual);
        }
      }
    }
  }

  Future<void> buy(String id) async {
    final response = await _iap.queryProductDetails({id});
    if (response.productDetails.isEmpty) return;
    final param = PurchaseParam(productDetails: response.productDetails.first);
    await _iap.buyNonConsumable(purchaseParam: param);
  }

  bool get isPremium => AppGlobal.instance.isPremium;

  void dispose() {
    _subscription.cancel();
  }
}
