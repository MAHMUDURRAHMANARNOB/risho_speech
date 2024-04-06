import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:risho_speech/models/validateSpokenSentenceDataModel.dart';

import '../api/api_service.dart';

class ValidateSentenceProvider extends ChangeNotifier {
  ApiService _apiService = ApiService();

  ValidateSentenceDataModel? _validateSentenceDataModel;

  ValidateSentenceDataModel? get validateSentenceResponse =>
      _validateSentenceDataModel;

  Future<Map<String, dynamic>> fetchValidateSentenceResponse(
    String userText,
  ) async {
    print("inside fetchValidateSentenceResponse $userText");
    try {
      // Use default audio file if audioFile is null
      // File selectedAudioFile = audioFile;

      Map<String, dynamic> response = await _apiService.validateSentence(
        text: userText,
      );
      _validateSentenceDataModel = ValidateSentenceDataModel.fromJson(response);
      print("Response from fetchValidateSentenceResponse: $response");
      notifyListeners();
      return response;
    } catch (error) {
      print('Error in getValidateSentenceResponse: $error');
      throw Exception('Failed to load data. Check your network connection.');
    }
  }
}
