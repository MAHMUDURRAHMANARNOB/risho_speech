import 'package:flutter/material.dart';
import 'package:risho_speech/models/suggestAnswerDataModel.dart';

import '../api/api_service.dart';

class SuggestAnswerProvider extends ChangeNotifier {
  ApiService _apiService = ApiService();

  SuggestAnswerDataModel? _suggestAnswerDataModel;

  SuggestAnswerDataModel? get suggestAnswerResponse => _suggestAnswerDataModel;

  Future<Map<String, dynamic>> fetchSuggestAnswerResponse(
    String userText,
  ) async {
    print("inside fetchSuggestAnswerResponse $userText");
    try {
      Map<String, dynamic> response = await _apiService.suggestAnswer(
        text: userText,
      );
      _suggestAnswerDataModel = SuggestAnswerDataModel.fromJson(response);
      print("Response from fetchSuggestAnswerResponse: $response");
      notifyListeners();
      return response;
    } catch (error) {
      print('Error in getSuggestAnswerResponse: $error');
      throw Exception('Failed to load data. Check your network connection.');
    }
  }
}
