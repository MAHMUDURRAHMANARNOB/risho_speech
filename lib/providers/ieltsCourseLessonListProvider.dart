import 'package:flutter/material.dart';

import '../api/api_service.dart';
import '../models/IeltsCoursesDataModel.dart';
import '../models/ieltsCourseLessonListDataModel.dart';

class IeltsCourseLessonListProvider with ChangeNotifier {
  ApiService _apiService = ApiService();
  bool _isLoading = false;
  String? _errorMessage;

  IeltsCourseLessonListDataModel? _ieltsCoursesLessonListDataModel;

  IeltsCourseLessonListDataModel? get ieltsCourseLessonListResponse =>
      _ieltsCoursesLessonListDataModel;

  // CourseListResponse? get courseListResponse => _courseListResponse;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  // final CourseApiController _apiController = CourseApiController();

  Future<void> fetchIeltsCourseLessonList(int courseId, int userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response =
          await _apiService.getIeltsCoursesLessonList(courseId, userId);
      _ieltsCoursesLessonListDataModel =
          IeltsCourseLessonListDataModel.fromJson(response);
      print("Response from fetchIeltsCoursesList: ${response}");
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      print('Error in fetchIeltsCoursesList: $_errorMessage');
      throw Exception('Failed to load data. Check your network connection.');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
