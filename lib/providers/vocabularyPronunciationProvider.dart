import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:risho_speech/models/validateSpokenSentenceDataModel.dart';

import '../api/api_service.dart';
import '../models/vocabularyPronunciationDataModel.dart';

class ValidatePronunciationProvider extends ChangeNotifier {
  ApiService _apiService = ApiService();

  ValidateVocabPronunciationDataModel? _validateVocabPronunciationDataModel;

  ValidateVocabPronunciationDataModel? get validateVocabPronunciationResponse =>
      _validateVocabPronunciationDataModel;

  Future<Map<String, dynamic>> fetchValidateVocabPronunciationResponse(
    int userId,
    String wordText,
    File? audioFile,
    String categoryName,
  ) async {
    print(
        "inside fetchValidateVocabPronunciationResponse $userId - $wordText - $categoryName");
    try {
      // Use default audio file if audioFile is null
      // File selectedAudioFile = audioFile;

      Map<String, dynamic> response =
          await _apiService.getVocabularyPronunciation(
        userId: userId,
        wordText: wordText,
        audioFile: audioFile,
        categoryName: categoryName,
      );
      print(
          "1stResponse from fetchValidateVocabPronunciationResponse: $response");
      _validateVocabPronunciationDataModel =
          ValidateVocabPronunciationDataModel.fromJson(response);
      print("Response from fetchValidateVocabPronunciationResponse: $response");
      notifyListeners();
      return response;
    } catch (error) {
      print('Error in fetchValidateVocabPronunciationResponse: $error');
      throw Exception('Failed to load data. Check your network connection.');
    }
  }
}
