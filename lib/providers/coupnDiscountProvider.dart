import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:risho_speech/models/coupnDiscountModel.dart';
import 'package:risho_speech/models/validateSpokenSentenceDataModel.dart';

import '../api/api_service.dart';

class CouponDiscountProvider extends ChangeNotifier {
  ApiService _apiService = ApiService();

  CouponDiscountDataModel? _couponDiscountDataModel;

  CouponDiscountDataModel? get couponDiscountResponse =>
      _couponDiscountDataModel;

  Future<Map<String, dynamic>> fetchCouponDiscountResponse(
    String couponcode,
    double amount,
  ) async {
    print("inside fetchCouponDiscountResponse $couponcode");
    try {
      // Use default audio file if audioFile is null
      // File selectedAudioFile = audioFile;

      Map<String, dynamic> response = await _apiService.getCouponDiscount(
        couponcode: couponcode,
        amount: amount,
      );
      _couponDiscountDataModel = CouponDiscountDataModel.fromJson(response);
      print("Response from fetchCouponDiscountResponse: $response");
      notifyListeners();
      return response;
    } catch (error) {
      print('Error in fetchCouponDiscountResponse: $error');
      throw Exception('Failed to load data. Check your network connection.');
    }
  }
}
