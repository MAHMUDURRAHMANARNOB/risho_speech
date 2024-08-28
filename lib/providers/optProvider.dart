import 'package:flutter/material.dart';
import '../api/api_service.dart';
import '../models/optResponseDataModel.dart';

class OtpProvider extends ChangeNotifier {
  ApiService _apiService = ApiService();
  OtpResponse? _otpResponseModel;

  OtpResponse? get otpResponseModel => _otpResponseModel;

  Future<void> fetchOtp(String emailAddress, String? phoneNo) async {
    try {
      final response = await ApiService.getOTP(emailAddress, phoneNo!);
      _otpResponseModel = OtpResponse.fromJson(response);
      print("Response from TranslationProvider: $response");
      notifyListeners();
    } catch (e) {
      notifyListeners();
      print('Error in TranslationProvider: $e');
    }
  }
}
