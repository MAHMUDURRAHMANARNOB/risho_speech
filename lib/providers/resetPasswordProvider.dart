import 'dart:convert';

import 'package:flutter/material.dart';

import '../api/api_service.dart';
import '../models/resetPasswordResponseDataModel.dart';

class ResetPasswordProvider extends ChangeNotifier {
  ResetPasswordResponseDataModel? _resetPassResponseModel;

  ResetPasswordResponseDataModel? get resetPasswordResponseDataModel =>
      _resetPassResponseModel;

  Future<void> fetchResponse(String emailAddress, String password) async {
    try {
      final response = await ApiService.resetPassword(emailAddress, password);
      _resetPassResponseModel =
          ResetPasswordResponseDataModel.fromJson(response);
      print("Response from ResetPassword: $response");
      print(json.encode(response));
      notifyListeners();
    } catch (e) {
      notifyListeners();
      print('Error in ResetPassword: $e');
    }
  }
}
