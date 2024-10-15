import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../api/api_service.dart';
import '../models/LanguageTutorResponseDataModel.dart';

class LanguageTutorResponseProvider with ChangeNotifier {
  ApiService _apiService = ApiService();

  LanguageTutorSuccessResponse? _successResponse;
  LanguageTutorNotSelectedResponse? _tutorNotSelectedResponse;
  bool _isLoading = false;

  LanguageTutorSuccessResponse? get successResponse => _successResponse;

  LanguageTutorNotSelectedResponse? get tutorNotSelectedResponse =>
      _tutorNotSelectedResponse;

  bool get isLoading => _isLoading;

  Future<void> fetchLanguageTutorResponse(
      int userid,
      String userName,
      String? courseId,
      File? audioFile,
      String nextLesson,
      String? langName) async {
    _setLoading(true);

    try {
      Map<String, dynamic> response =
          await _apiService.getLanguageTutorResponse(
              userid, userName, courseId, audioFile, nextLesson, langName);

      // final data = json.decode(response.body);
      if (response['errorcode'] == 200) {
        // Parse success response
        _successResponse = LanguageTutorSuccessResponse.fromJson(response);
        _tutorNotSelectedResponse = null; // Clear error response
      } else if (response['errorcode'] == 210) {
        // Parse error response
        _tutorNotSelectedResponse =
            LanguageTutorNotSelectedResponse.fromJson(response);
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
