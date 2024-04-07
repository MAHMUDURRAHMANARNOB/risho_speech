import 'package:flutter/material.dart';
import '../api/api_service.dart';
import '../models/nextQuestionDataModel.dart';

class NextQuestionProvider extends ChangeNotifier {
  ApiService _apiService = ApiService();

  NextQuestionDataModel? _nextQuestionDataModel;

  NextQuestionDataModel? get nextQuestionResponse => _nextQuestionDataModel;

  Future<Map<String, dynamic>> fetchNextQuestionResponse(
    int userid,
    int conversationid,
    String sessionID,
    String replyText,
    String isfemale,
    String userName,
  ) async {
    print("inside fetchNextQuestionResponse $userid");
    try {
      Map<String, dynamic> response = await _apiService.getNextConversation(
        userid: userid,
        conversationid: conversationid,
        sessionID: sessionID,
        replyText: replyText,
        isfemale: isfemale,
        userName: userName,
      );
      _nextQuestionDataModel = NextQuestionDataModel.fromJson(response);
      print("Response from fetchNextQuestionResponse: $response");
      notifyListeners();
      return response;
    } catch (error) {
      print('Error in getNextQuestionResponse: $error');
      throw Exception('Failed to load data. Check your network connection.');
    }
  }
}
