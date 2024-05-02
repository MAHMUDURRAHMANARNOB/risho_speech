import 'package:flutter/material.dart';
import 'package:risho_speech/api/api_service.dart';

import '../models/VocabularySentenseListDataModel.dart';

class VocabularySentenceListProvider with ChangeNotifier {
  ApiService _apiService = ApiService();

  VocabularySentenceListDataModel? _vocabularySentenceListDataModel;
  VocabularySentenceListDataModel? get vocabularySentenceListResponse =>
      _vocabularySentenceListDataModel;

  Future<void> fetchVocabularySentenceList(int vocabularyId) async {
    try {
      print(" -- $vocabularyId");
      final response =
          await _apiService.getVocabularySentenceList(vocaId: vocabularyId);

      _vocabularySentenceListDataModel =
          VocabularySentenceListDataModel.fromJson(response);
      print("Response from fetchVocabularySentenceList: ${response}");
      notifyListeners();
      // return response;
    } catch (error) {
      print('Error in fetchVocabularySentenceList: $error');
      throw Exception('Failed to load data. Check your network connection.');
    }
  }
}
