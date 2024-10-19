import 'package:flutter/material.dart';
import 'package:risho_speech/api/api_service.dart';

class DeleteUserProvider with ChangeNotifier {
  final ApiService apiService = ApiService(); // Instance of the API class
  bool _isLoading = false;
  String _errorMessage = '';

  bool get isLoading => _isLoading;

  String get errorMessage => _errorMessage;

  Future<bool> deleteUser(int userid, String reason) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await apiService.getDeleteResponse(userid, reason);

      // Handle response here
      if (response['errorcode'] == "200") {
        // Assuming the API returns 'success'
        _isLoading = false;
        notifyListeners();
        return true; // Success
      } else {
        _errorMessage = 'Failed to delete user';
        _isLoading = false;
        notifyListeners();
        return false; // Failure
      }
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
