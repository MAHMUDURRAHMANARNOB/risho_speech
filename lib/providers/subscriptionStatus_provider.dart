import 'package:flutter/material.dart';
import 'dart:convert';

import '../api/api_service.dart';
import '../models/subscriptionStatusDataModel.dart';

class SubscriptionStatusProvider extends ChangeNotifier {
  SubscriptionStatusDataModel? _subscriptionStatus;

  SubscriptionStatusDataModel? get subscriptionStatus => _subscriptionStatus;

  Future<void> fetchSubscriptionData(int userId) async {
    print('Fetching subscriptionData for userId: $userId');

    try {
      final newSubscriptionStatus =
          await ApiService.fetchSubscriptionStatus(userId);

      if (newSubscriptionStatus.errorCode == 200) {
        _subscriptionStatus = newSubscriptionStatus;
        notifyListeners();
      } else {
        // Handle the case when the response has an error code other than 200
        print(
            'Failed to fetch subscription data. Error code: ${newSubscriptionStatus.errorCode}');
      }
    } catch (e) {
      // Handle the case when there is an exception during the API call
      print('Error fetching subscription data: $e');
    }
  }
}
