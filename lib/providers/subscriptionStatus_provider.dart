import 'package:flutter/material.dart';
import '../api/api_service.dart';
import '../models/subscriptionStatusDataModel.dart';

class SubscriptionStatusProvider extends ChangeNotifier {
  SubscriptionStatusDataModel? _subscriptionStatus;
  bool _isFetching = false;

  SubscriptionStatusDataModel? get subscriptionStatus => _subscriptionStatus;

  bool get isFetching => _isFetching;

  void setFetching(bool value) {
    _isFetching = value;
    notifyListeners();
  }

  void updateSubscriptionStatus(SubscriptionStatusDataModel newStatus) {
    _subscriptionStatus = newStatus;
    notifyListeners();
  }

  Future<void> fetchSubscriptionData(int userId) async {
    if (_isFetching) return;
    setFetching(true);

    try {
      final newSubscriptionStatus =
          await ApiService.fetchSubscriptionStatus(userId);

      if (newSubscriptionStatus.errorCode == 200) {
        _subscriptionStatus = newSubscriptionStatus;
        notifyListeners();
      } else {
        print(
            'Failed to fetch subscription data. Error code: ${newSubscriptionStatus.errorCode}');
      }
    } catch (e) {
      print('Error fetching subscription data: $e');
    } finally {
      setFetching(false);
    }
  }

  double get audioRemains => _subscriptionStatus?.audioReamins ?? 0.0;
}
