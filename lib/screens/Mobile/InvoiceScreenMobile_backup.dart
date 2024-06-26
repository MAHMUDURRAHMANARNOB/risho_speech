import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shurjopay/models/config.dart';
import 'package:shurjopay/models/payment_verification_model.dart';
import 'package:shurjopay/models/shurjopay_request_model.dart';
import 'package:shurjopay/models/shurjopay_response_model.dart';
import 'package:shurjopay/shurjopay.dart';
import 'package:shurjopay/utilities/functions.dart';

import '../../api/api_service.dart';

class PurchasePage extends StatefulWidget {
  const PurchasePage(
      {super.key,
      required this.packageName,
      required this.couponPartnerId,
      required this.generatedTransectionId,
      required this.userID,
      required this.packageID,
      required this.packageValue,
      required this.discountValue,
      required this.mainAmount,
      required this.couponDiscountAmount,
      required this.payableAmount});

  final String? packageName;
  final int generatedTransectionId, userID, packageID;
  final int? couponPartnerId;
  final double packageValue,
      discountValue,
      mainAmount,
      couponDiscountAmount,
      payableAmount;

  @override
  State<PurchasePage> createState() => _PurchasePageState();
}

class _PurchasePageState extends State<PurchasePage> {
  // bool _isLoading = false;
  ShurjoPay _shurjoPay = ShurjoPay();
  late ShurjopayConfigs _shurjopayConfigs;

  late int _generatedTransectionId = 0;
  late int _userID = 0;
  late int _packageID;
  late String _packageName;
  late double _packageValue;
  late double _discountValue;
  late double _payableAmount;

  late double _mainAmount;
  late double _couponDiscountAmount = 0.0;
  late int? _couponPartnerId = null;

  @override
  void initState() {
    super.initState();
    _packageID = widget.packageID;
    _userID = widget.userID;
    _packageName = widget.packageName!;
    _packageValue = widget.packageValue;
    _discountValue = widget.discountValue;
    _payableAmount = widget.payableAmount;
    _mainAmount = widget.payableAmount;
    _generatedTransectionId = widget.generatedTransectionId;
    _couponPartnerId = widget.couponPartnerId;

    initializeShurjopay(environment: "live");
    _shurjopayConfigs = ShurjopayConfigs(
      prefix: "RIG",
      userName: "Risho.Guru",
      password: "rishyqb8\$ts&\$#dn",
      clientIP: "127.0.0.1",
    );
    _initiatePayment();
  }

  void _initiatePayment() async {
    // setState(() {
    //   _isLoading = true;
    // });

    try {
      await ApiService.initiatePayment(
        _userID,
        _packageID,
        _generatedTransectionId.toString(),
        _payableAmount,
        _mainAmount,
        _couponDiscountAmount,
        _couponPartnerId,
      );

      ShurjopayRequestModel requestModel = ShurjopayRequestModel(
        configs: _shurjopayConfigs,
        currency: "BDT",
        amount: _payableAmount,
        orderID: _generatedTransectionId.toString(),
        customerName: "widget.packageName",
        customerPhoneNumber: "01751111111",
        customerAddress: "Bangladesh",
        customerCity: "Dhaka",
        customerPostcode: "1230",
        returnURL: "https://www.sandbox.shurjopayment.com/return_url",
        cancelURL: "https://www.sandbox.shurjopayment.com/cancel_url",
      );

      ShurjopayResponseModel shurjopayResponseModel = await _shurjoPay
          .makePayment(context: context, shurjopayRequestModel: requestModel);

      if (shurjopayResponseModel.status == 'Success') {
        _verifyPayment(shurjopayResponseModel.shurjopayOrderID!);
      } else {
        _showToast('Payment Failed: ${shurjopayResponseModel.message}');
      }
    } catch (error) {
      _showToast('Payment Error: $error');
    } finally {
      // setState(() {
      //   _isLoading = false;
      // });
    }
  }

  ShurjopayVerificationModel shurjopayVerificationModel =
      ShurjopayVerificationModel();

  void _verifyPayment(String transactionId) async {
    try {
      shurjopayVerificationModel =
          await _shurjoPay.verifyPayment(orderID: transactionId);
      if (shurjopayVerificationModel.spCode == "1000") {
        _showToast('Payment Verified Successfully');
        print(
            "Payment Varified - ${shurjopayVerificationModel.spMessage}, ${shurjopayVerificationModel.spCode}");
        _receivePayment(/*shurjopayVerificationModel*/);
      } else {
        _showToast('Payment Verification Failed');
        print(
            "Payment not Varified - ${shurjopayVerificationModel.spMessage}, ${shurjopayVerificationModel.spCode}");
      }
    } catch (error) {
      _showToast('Verification Error: $error');
    }
  }

  void _receivePayment(/*ShurjopayVerificationModel verification*/) async {
    // setState(() {
    //   _isLoading = true;
    // });

    try {
      ApiService.receivePayment(
        _userID,
        _packageID,
        _generatedTransectionId.toString(),
        shurjopayVerificationModel.spCode == "1000" ? "VALID" : "FAILED",
        //STATUS
        double.tryParse(shurjopayVerificationModel.amount != null
            ? shurjopayVerificationModel.amount!
            : "0")!,
        //amount
        shurjopayVerificationModel.receivedAmount != null
            ? shurjopayVerificationModel.receivedAmount.toString()
            : "0",
        //store amount
        shurjopayVerificationModel.cardNumber != null
            ? shurjopayVerificationModel.cardNumber!
            : "null",
        //cardNumber
        shurjopayVerificationModel.bankTrxId != null
            ? shurjopayVerificationModel.bankTrxId!
            : "null",
        //bankTranId
        shurjopayVerificationModel.currency != null
            ? shurjopayVerificationModel.currency!
            : "null",
        //currencyType
        shurjopayVerificationModel.cardHolderName != null
            ? shurjopayVerificationModel.cardHolderName!
            : "null",
        //cardIssuer
        shurjopayVerificationModel.bankStatus != null
            ? shurjopayVerificationModel.bankStatus!
            : "null",
        //cardBrand
        shurjopayVerificationModel.transactionStatus != null
            ? shurjopayVerificationModel.transactionStatus!
            : "null",
        //cardIssuerCountry
        shurjopayVerificationModel.spCode != null
            ? shurjopayVerificationModel.spCode!
            : "null",
        //riskLevel
        shurjopayVerificationModel.spMessage != null
            ? shurjopayVerificationModel.spMessage!
            : "null", //risk title
      );
      /*await ApiService.receivePayment(
        _userID,
        _packageID,
        _generatedTransectionId.toString(),
        verification.spCode == "1000" ? "VALID" : "FAILED",
        double.tryParse(verification.amount ?? "0")!,
        verification.receivedAmount?.toString() ?? "0",
        verification.cardNumber ?? "null",
        verification.bankTrxId ?? "null",
        verification.currency ?? "null",
        verification.cardHolderName ?? "null",
        verification.bankStatus ?? "null",
        verification.transactionStatus ?? "null",
        verification.spCode ?? "null",
        verification.spMessage ?? "null",
      );*/
      if (shurjopayVerificationModel.spCode.toString() == "1000") {
        /*setState(() {
          status = "true";
        });*/
        Fluttertoast.showToast(
          msg:
              "Transaction successful. Transaction ID: ${shurjopayVerificationModel.bankTrxId}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      } else if (shurjopayVerificationModel.spCode.toString() == "1011" ||
          shurjopayVerificationModel.spCode.toString() == "1002") {
        /*setState(() {
          status = "false";
        });*/
        Fluttertoast.showToast(
          msg: "Transaction closed by user.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      } else {
        /*setState(() {
          status = "false";
        });*/
        Fluttertoast.showToast(
          msg: "Transaction failed.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
        // Perform any actions after successful payment (e.g., navigate to success screen)
      }
      // _showToast('Payment received and processed successfully.');
    } catch (error) {
      _showToast('Receiving Payment Error: $error');
    } finally {
      // setState(() {
      //   _isLoading = false;
      // });
    }
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
      ),
      body: /*_isLoading
          ? Center(child: SpinKitCircle(color: Colors.blue))
          : */
          Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Enter Name'),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(labelText: 'Enter Amount'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _initiatePayment,
              child: Text('Proceed with Payment'),
            ),
          ],
        ),
      ),
    );
    // _initiatePayment());
  }
}
