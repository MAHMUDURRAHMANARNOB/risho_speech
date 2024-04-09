import 'package:flutter/material.dart';

import '../api/api_service.dart'; // Import your ApiService

class UserCreationProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService(); // Initialize your ApiService

  Future<bool> createUser(
    String userId,
    String username,
    String name,
    String email,
    String mobile,
    String password,
    String userType,
    String school,
    String address,
    String marketingSource,
  ) async {
    try {
      final bool success = await ApiService.createUser(
        userId,
        username,
        name,
        email,
        mobile,
        password,
        userType,
        school,
        address,
        marketingSource,
      );

      // Notify listeners about the result
      notifyListeners();

      return success;
    } catch (e) {
      // Exception occurred
      print('Exception creating user: $e');
      return false;
    }
  }
}
