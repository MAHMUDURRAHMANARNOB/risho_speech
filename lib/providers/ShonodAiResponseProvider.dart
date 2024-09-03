import 'dart:math';

import 'package:flutter/material.dart';

import '../api/api_service.dart';
import '../models/ShonodAiResponseDataModel.dart';

class ShonodAiResponseProvider extends ChangeNotifier {
  ApiService _apiService = ApiService();

  ShonodAiResponseDataModel? _shonodAiResonseDataModel;

  ShonodAiResponseDataModel? get spokenLessonListResponse =>
      _shonodAiResonseDataModel;

  Future<void> fetchShonodAiResponse(
    String professiontitle,
    String QuestionText,
    String isBangla,
    String contextArea,
    int userid,
    String? sessionID,
  ) async {
    print("inside fetchShonodAiResponse");
    try {
      final response = await _apiService.getShonodAI(professiontitle,
          QuestionText, isBangla, contextArea, userid, sessionID);
      _shonodAiResonseDataModel = ShonodAiResponseDataModel.fromJson(response);
      // print("Response from fetchSpokenLessonListResponse: $response}");
      notifyListeners();
    } catch (error) {
      print('Error in fetchShonodAiResponse: $error');
      throw Exception('Failed to load data. Check your network connection.');
    }
  }
}
