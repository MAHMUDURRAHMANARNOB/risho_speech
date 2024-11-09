/*
import 'dart:async';

import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:flutter_inapp_purchase/modules.dart';

class InAppPurchaseService {
  final List<IAPItem> _products = [];
  StreamSubscription? _purchaseUpdatedSubscription;

  InAppPurchaseService() {
    _initialize();
  }

  void _initialize() async {
    // Listen for purchase updates
    _purchaseUpdatedSubscription =
        FlutterInappPurchase.purchaseUpdated.listen(_handlePurchaseUpdate);
  }

  Future<void> dispose() async {
    await FlutterInappPurchase.instance.finalize();
    _purchaseUpdatedSubscription?.cancel();
  }

  Future<void> fetchProducts(List<String> productIds) async {
    try {
      List<IAPItem> items =
          await FlutterInappPurchase.instance.getProducts(productIds);
      _products.clear();
      _products.addAll(items);
    } catch (e) {
      print("Error fetching products: $e");
    }
  }

  Future<void> buyProduct(IAPItem product) async {
    try {
      await FlutterInappPurchase.instance.requestPurchase(product.productId!);
    } catch (e) {
      print("Error buying product: $e");
    }
  }

  void _handlePurchaseUpdate(PurchasedItem? purchasedItem) async {
    if (purchasedItem == null) return;

    // Check if the purchase is successful
    if (purchasedItem.transactionStateIOS == TransactionState.purchased) {
      // Unlock non-consumable content for the user
      print("Purchase successful for: ${purchasedItem.productId}");
      // Additional logic to provide the purchased feature
    }

    // Complete purchase transaction
    await FlutterInappPurchase.instance.finishTransaction(purchasedItem);
  }
}
*/
