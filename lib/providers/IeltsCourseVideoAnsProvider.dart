import 'package:flutter/material.dart';

import '../api/api_service.dart';
import '../models/IeltsCoursesDataModel.dart';
import '../models/IeltsLessonReplyDataModel.dart';

class IeltsLessonReplyProvider with ChangeNotifier {
  ApiService _apiService = ApiService();
  bool _isLoading = false;
  String? _errorMessage;

  IeltsLessonReplyDataModel? _ieltsLessonReplyDataModel;

  IeltsLessonReplyDataModel? get ieltsCourseListResponse =>
      _ieltsLessonReplyDataModel;

  // CourseListResponse? get courseListResponse => _courseListResponse;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  // final CourseApiController _apiController = CourseApiController();

  Future<void> fetchIeltsLessonReply(int lessoncontentID, String Question,
      String userid, String isVideo, String? sessionID) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      print(
          "Response from fetchIeltsLessonReply: ${lessoncontentID} $Question, $userid, $isVideo, $sessionID}");

      final response = await _apiService.getIeltsLessonReply(
          lessoncontentID, Question, userid, isVideo, sessionID);
      _ieltsLessonReplyDataModel = IeltsLessonReplyDataModel.fromJson(response);
      print("Response from fetchIeltsLessonReply: ${response}");
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      print('Error in fetchIeltsLessonReply: $_errorMessage');
      throw Exception('Failed to load data. Check your network connection.');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
