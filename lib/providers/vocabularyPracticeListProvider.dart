import 'package:flutter/material.dart';
import 'package:risho_speech/api/api_service.dart';

import '../models/vocabularyCategoryListDataModel.dart';
import '../models/vocabularyPracticeListDataModel.dart';

class VocabularyPracticeProvider with ChangeNotifier {
  ApiService _apiService = ApiService();

  VocabularyPracticeListDataModel? _vocabularyPracticeListDataModel;
  VocabularyPracticeListDataModel? get vocabularyPracticeResponse =>
      _vocabularyPracticeListDataModel;

  Future<void> fetchVocabularyPracticeList(int vocCatId) async {
    try {
      print(" -- $vocCatId");
      final response = await _apiService.getVocabularyList(vocaCatId: vocCatId);

      _vocabularyPracticeListDataModel =
          VocabularyPracticeListDataModel.fromJson(response);
      print("Response from fetchVocabularyPracticeList: ${response}");
      notifyListeners();
      // return response;
    } catch (error) {
      print('Error in fetchVocabularyPracticeList: $error');
      throw Exception('Failed to load data. Check your network connection.');
    }
  }
}
