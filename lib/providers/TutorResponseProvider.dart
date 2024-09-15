import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../api/api_service.dart';
import '../models/TutorResponseDataModel.dart';

class TutorResponseProvider with ChangeNotifier {
  ApiService _apiService = ApiService();

  TutorSuccessResponse? _successResponse;
  TutorNotSelectedResponse? _tutorNotSelectedResponse;
  bool _isLoading = false;

  TutorSuccessResponse? get successResponse => _successResponse;
  TutorNotSelectedResponse? get tutorNotSelectedResponse =>
      _tutorNotSelectedResponse;
  bool get isLoading => _isLoading;

  Future<void> fetchEnglishTutorResponse(
      int userid, String userName, String? courseId, File? audioFile) async {
    _setLoading(true);

    try {
      Map<String, dynamic> response = await _apiService.getEnglishTutorResponse(
          userid, userName, courseId, audioFile);

      // final data = json.decode(response.body);
      if (response['errorcode'] == 200) {
        // Parse success response
        _successResponse = TutorSuccessResponse.fromJson(response);
        _tutorNotSelectedResponse = null; // Clear error response
      } else if (response['errorcode'] == 210) {
        // Parse error response
        _tutorNotSelectedResponse = TutorNotSelectedResponse.fromJson(response);
        _successResponse = null; // Clear success response
      }
    } catch (error) {
      // Handle any errors here
      throw error.toString();
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
