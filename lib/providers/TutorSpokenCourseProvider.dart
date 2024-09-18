import 'package:flutter/material.dart';

import '../api/api_service.dart';
import '../models/tutorSpokenCourseDataModel.dart'; // Import your API service class

class TutorSpokenCourseProvider with ChangeNotifier {
  TutorSpokenCourseResponse? _courseResponse;
  bool _isLoading = false;
  String _errorMessage = '';

  // Getters
  TutorSpokenCourseResponse? get courseResponse => _courseResponse;

  bool get isLoading => _isLoading;

  String get errorMessage => _errorMessage;

  // Method to fetch spoken courses
  Future<void> fetchSpokenCourses() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final response =
          await ApiService().getSpokenCourse(); // Call your API method here

      // Parse response data
      _courseResponse = TutorSpokenCourseResponse.fromJson(response);
    } catch (error) {
      _errorMessage = error.toString();
      _courseResponse = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
