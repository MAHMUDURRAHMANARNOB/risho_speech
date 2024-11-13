import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../ui/colors.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class InvoiceScreenIOS extends StatefulWidget {
  final int packageID;
  final String packageName;
  final double packageValue;
  final double discountValue;
  final double payableAmount;

  const InvoiceScreenIOS(
      {super.key,
      required this.packageID,
      required this.packageName,
      required this.packageValue,
      required this.discountValue,
      required this.payableAmount});

  @override
  State<InvoiceScreenIOS> createState() => _InvoiceScreenIOSState();
}

class _InvoiceScreenIOSState extends State<InvoiceScreenIOS> {
  late String status = "nothing";
  late int generatedTransectionId = 0;
  late int userID = 0;
  late int _packageID;
  late String _packageName;
  late double _packageValue;
  late double _discountValue;
  late double _payableAmount;

  late double _mainAmount;
  late double _amount;
  late double _couponDiscountAmount = 0.0;
  late int? _couponPartnerId = null;

  bool _isApplied = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _packageID = widget.packageID;
    _packageName = widget.packageName;
    _packageValue = widget.packageValue;
    _discountValue = widget.discountValue;
    _payableAmount = widget.payableAmount;
    _mainAmount = widget.payableAmount;
    _isApplied = false;
    // _loadPaymentConfiguration();
  }

  void initInAppPurchase() async {
    final bool available = await InAppPurchase.instance.isAvailable();
    if (!available) {
      // Handle store not available error
      return;
    }

    // Query for products
    const Set<String> productIds = {'product_id_1', 'product_id_2'};
    final ProductDetailsResponse response =
        await InAppPurchase.instance.queryProductDetails(productIds);
    if (response.notFoundIDs.isNotEmpty) {
      // Handle product not found
    } else {
      // Store the product details to display in UI or initiate purchases
      final List<ProductDetails> products = response.productDetails;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Invoice",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(10.0),
              padding: const EdgeInsets.all(10.0),
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.primaryCardColor,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.white),
              ),
              child: Column(
                children: [
                  /*Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("PackageID "),
                      Text("${widget.packageID}"),
                    ],
                  ),
                  Divider(
                    thickness: 2,
                    color: Colors.white,
                  ),*/

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        "assets/images/risho_guru_icon.png",
                        width: 100,
                        height: 100,
                      ),
                      Expanded(
                        child: Text(
                          textAlign: TextAlign.end,
                          _packageName,
                          style: const TextStyle(
                              fontSize: 24,
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    thickness: 2,
                    color: Colors.white,
                  ),
                  /*Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Base Price ",
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        _packageValue.toString(),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const Divider(
                    thickness: 2,
                    color: Colors.white,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Discount ",
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        _discountValue.toString(),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const Divider(
                    thickness: 2,
                    color: Colors.white,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Main Amount ",
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        _mainAmount.toString(),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const Divider(
                    thickness: 2,
                    color: Colors.white,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Coupon Discount ",
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        _couponDiscountAmount.toString(),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const Divider(
                    thickness: 2,
                    color: Colors.white,
                  ),*/
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Payable Amount ",
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        _payableAmount.toStringAsFixed(2),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    thickness: 2,
                    color: Colors.white,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "TransectionId",
                        style: TextStyle(fontSize: 16),
                      ),
                      status == "true"
                          ? Text(
                              "$generatedTransectionId",
                              style: const TextStyle(fontSize: 16),
                            )
                          : const Text(
                              "No transaction yet",
                              style: TextStyle(fontSize: 16),
                            ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
