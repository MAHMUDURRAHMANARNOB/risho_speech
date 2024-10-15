import 'package:flutter/material.dart';

import '../api/api_service.dart';
import '../models/languageListDataModel.dart';

class LanguageListProvider with ChangeNotifier {
  ApiService _apiService = ApiService();
  bool _isLoading = false;
  String? _errorMessage;

  LanguageListDataModel? _languageListDataModel;

  LanguageListDataModel? get languageListResponse => _languageListDataModel;

  // CourseListResponse? get courseListResponse => _courseListResponse;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  // final CourseApiController _apiController = CourseApiController();

  Future<void> fetchLanguageList() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.getLanguageList();
      _languageListDataModel = LanguageListDataModel.fromJson(response);
      // print("Response from fetchIeltsCoursesList: ${response}");
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      print('Error in fetchLanguageList: $_errorMessage');
      throw Exception('Failed to load data. Check your network connection.');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
