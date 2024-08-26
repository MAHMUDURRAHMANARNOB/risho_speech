import 'package:flutter/material.dart';

import '../api/api_service.dart';
import '../models/IeltsCoursesDataModel.dart';

class IeltsCourseListProvider with ChangeNotifier {
  ApiService _apiService = ApiService();
  bool _isLoading = false;
  String? _errorMessage;

  Ieltscoursesdatamodel? _ieltsCoursesListDataModel;

  Ieltscoursesdatamodel? get ieltsCourseListResponse =>
      _ieltsCoursesListDataModel;

  // CourseListResponse? get courseListResponse => _courseListResponse;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  // final CourseApiController _apiController = CourseApiController();

  Future<void> fetchIeltsCourseList() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.fetchIeltsCoursesList();
      _ieltsCoursesListDataModel = Ieltscoursesdatamodel.fromJson(response);
      // print("Response from fetchIeltsCoursesList: ${response}");
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      print('Error in fetchVocabularyCategoryList: $_errorMessage');
      throw Exception('Failed to load data. Check your network connection.');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
