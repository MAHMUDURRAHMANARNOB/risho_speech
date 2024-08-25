import 'package:flutter/material.dart';

import '../api/api_service.dart';
import '../models/IeltsCoursesDataModel.dart';
import '../models/IeltsLessonContentDataModel.dart';
import '../models/ieltsCourseLessonListDataModel.dart';

class IeltsCourseLessonProvider with ChangeNotifier {
  ApiService _apiService = ApiService();
  bool _isLoading = false;
  String? _errorMessage;

  LessonContentDataModel? _ieltsCoursesLessonDataModel;

  LessonContentDataModel? get ieltsCourseLessonResponse =>
      _ieltsCoursesLessonDataModel;

  // CourseListResponse? get courseListResponse => _courseListResponse;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  // final CourseApiController _apiController = CourseApiController();

  Future<void> fetchIeltsCourseLesson(int lessonId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.getIeltsCoursesLesson(lessonId);
      _ieltsCoursesLessonDataModel = LessonContentDataModel.fromJson(response);
      print("Response from fetchIeltsCourseLesson: $response");
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      print('Error in fetchIeltsCourseLesson: $_errorMessage');
      throw Exception('Failed to load data. Check your network connection.');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
