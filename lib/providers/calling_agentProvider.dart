import 'package:flutter/material.dart';
import 'package:risho_speech/models/CallingAgentDataModel.dart';

import '../api/api_service.dart';

class CallingAgentListProvider extends ChangeNotifier {
  ApiService _apiService = ApiService();

  CallingAgentDataModel? _callingAgentDataModel;

  CallingAgentDataModel? get callingAgentListResponse => _callingAgentDataModel;

  Future<void> fetchCallingAgentListResponse() async {
    print("inside fetchCallingAgentListResponse");
    try {
      final response = await _apiService.getCallingAgent();
      _callingAgentDataModel = CallingAgentDataModel.fromJson(response);
      print("Response from fetchCallingAgentListResponse: ${response}");
      notifyListeners();
    } catch (error) {
      print('Error in fetchCallingAgentListResponse: $error');
      throw Exception('Failed to load data. Check your network connection.');
    }
  }
}
