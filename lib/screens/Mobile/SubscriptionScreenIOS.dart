import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:risho_speech/ui/colors.dart';
import 'package:risho_speech/utils/constants/colors.dart';

class SubscriptionScreenIOS extends StatefulWidget {
  const SubscriptionScreenIOS({super.key});

  @override
  State<SubscriptionScreenIOS> createState() => _SubscriptionScreenIOSState();
}

class _SubscriptionScreenIOSState extends State<SubscriptionScreenIOS> {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  List<ProductDetails> _products = [];
  bool _isAvailable = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _initializeInAppPurchase();

    _inAppPurchase.purchaseStream.listen((purchaseDetailsList) {
      _handlePurchaseUpdates(purchaseDetailsList);
    });
  }

  // Initialization
  Future<void> _initializeInAppPurchase() async {
    _isAvailable = await _inAppPurchase.isAvailable();
    if (_isAvailable) {
      await _loadProducts();
    }
    setState(() {
      _loading = false;
    });
  }

  // Query available products
  Future<void> _loadProducts() async {
    const Set<String> _productIds = {'Starter10', 'Monthly6', 'EnglishSpeak7'};
    final ProductDetailsResponse response =
        await _inAppPurchase.queryProductDetails(_productIds);

    if (response.productDetails.isEmpty) {
      _products = [
        ProductDetails(
          id: 'dummy_package',
          title: 'Dummy Package 1',
          description: 'This is a placeholder package for testing layout',
          price: '\$0.99',
          currencyCode: 'USD',
          rawPrice: 152,
        ),
        ProductDetails(
          id: 'dummy_package_2',
          title: 'Dummy Package 2',
          description: 'Another placeholder package for testing layout',
          price: '\$1.99',
          currencyCode: 'USD',
          rawPrice: 199,
        ),
      ];
    } else {
      // If real products are found, assign them to _products
      _products = response.productDetails;
    }
    print(
        "Loaded products: ${_products.map((product) => product.title).toList()}");

    // Set state to update the UI
    setState(() {});
  }

  // Buying a consumable product
  void _buyProduct(ProductDetails productDetails) {
    // Check if the product is a dummy product based on its ID or other unique attributes
    if (productDetails.title.startsWith("Dummy")) {
      // You can show a dialog or a snackbar for testing purposes
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("This is a test product and cannot be purchased.")),
      );
      return;
    }

    final PurchaseParam purchaseParam =
        PurchaseParam(productDetails: productDetails);
    _inAppPurchase.buyConsumable(
      purchaseParam: purchaseParam,
      autoConsume: true,
    );
  }

  void _handlePurchaseUpdates(List<PurchaseDetails> purchaseDetailsList) {
    for (var purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.purchased) {
        // Unlock content, e.g., add credits to the user’s account
      } else if (purchaseDetails.status == PurchaseStatus.error) {
        // Handle purchase error
      }

      // Complete the purchase (required for consumables)
      if (purchaseDetails.pendingCompletePurchase) {
        _inAppPurchase.completePurchase(purchaseDetails);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Subscription Plans",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: _loading
          ? Center(
              child: SpinKitChasingDots(
              color: AppColors.primaryColor,
            ))
          : !_isAvailable
              ? Center(child: Text("Store not available"))
              : _products.isEmpty
                  ? Center(child: Text("No products found"))
                  : Column(
                      // Wrap in Column for Expanded ListView
                      children: [
                        _buildProductList(),
                      ],
                    ),
    );
  }

  Widget _buildProductList() {
    return Expanded(
      child: ListView.builder(
        // physics: NeverScrollableScrollPhysics(),
        itemCount: _products.length,
        itemBuilder: (context, index) {
          final product = _products[index];
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            decoration: BoxDecoration(
              color: AppColors.primaryCardColor,
              borderRadius: BorderRadius.circular(
                8.0,
              ),
            ),
            child: ListTile(
              title: Text(
                product.title,
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(product.description),
              trailing: TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: AppColors.primaryColor),
                onPressed: () => _buyProduct(product),
                child: Text(
                  "Buy for ${product.price}",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
