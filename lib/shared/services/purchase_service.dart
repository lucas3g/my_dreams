import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:injectable/injectable.dart';
import 'package:my_dreams/core/domain/entities/app_global.dart';
import 'package:my_dreams/core/domain/entities/subscription_plan.dart';
import 'package:my_dreams/modules/subscription/domain/entities/purchase_state.dart';

@singleton
class PurchaseService extends ChangeNotifier {
  final InAppPurchase _iap = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  final StreamController<PurchaseState> _controller =
      StreamController<PurchaseState>.broadcast();

  final Map<String, String> _prices = {};

  static const String weeklyId = 'weekly_plan';
  static const String monthlyId = 'monthly_plan';
  static const String annualId = 'annual_plan';

  Stream<PurchaseState> get stream => _controller.stream;

  String priceFor(String id) => _prices[id] ?? '';

  Future<void> init() async {
    final bool available = await _iap.isAvailable();
    if (!available) return;
    _subscription = _iap.purchaseStream.listen(_onPurchaseUpdated);
    await _iap.restorePurchases();
    await _loadPrices();
  }

  void _onPurchaseUpdated(List<PurchaseDetails> purchases) {
    for (final purchase in purchases) {
      if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        if (purchase.productID == weeklyId) {
          AppGlobal.instance.setPlan(SubscriptionPlan.weekly);
          notifyListeners();
          _controller.add(PurchaseState.success);
        } else if (purchase.productID == monthlyId) {
          AppGlobal.instance.setPlan(SubscriptionPlan.monthly);
          notifyListeners();
          _controller.add(PurchaseState.success);
        } else if (purchase.productID == annualId) {
          AppGlobal.instance.setPlan(SubscriptionPlan.annual);
          notifyListeners();
          _controller.add(PurchaseState.success);
        }
      }
      if (purchase.status == PurchaseStatus.error) {
        _controller.add(PurchaseState.error);
      }
      if (purchase.status == PurchaseStatus.canceled) {
        _controller.add(PurchaseState.canceled);
      }
    }
  }

  Future<void> _loadPrices() async {
    try {
      final response = await _iap.queryProductDetails({
        weeklyId,
        monthlyId,
        annualId,
      });
      for (final product in response.productDetails) {
        _prices[product.id] = product.price;
      }
      notifyListeners();
    } catch (_) {
      // ignore errors
    }
  }

  Future<void> buy(String id) async {
    try {
      _controller.add(PurchaseState.loading);
      final response = await _iap.queryProductDetails({id});
      if (response.productDetails.isEmpty) {
        _controller.add(PurchaseState.error);
        return;
      }
      final param = PurchaseParam(
        productDetails: response.productDetails.first,
      );
      await _iap.buyNonConsumable(purchaseParam: param);
    } catch (_) {
      _controller.add(PurchaseState.error);
    }
  }

  bool get isPremium => AppGlobal.instance.isPremium;

  @override
  void dispose() {
    _subscription.cancel();
    _controller.close();

    super.dispose();
  }
}
