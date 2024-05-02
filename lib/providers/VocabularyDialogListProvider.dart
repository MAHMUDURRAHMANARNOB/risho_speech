import 'package:flutter/material.dart';
import 'package:risho_speech/api/api_service.dart';

import '../models/VocabularyDialogListDataModel.dart';

class VocabularyDialogListProvider with ChangeNotifier {
  ApiService _apiService = ApiService();

  VocabularyDialogListDataModel? _vocabularyDialogListDataModel;
  VocabularyDialogListDataModel? get vocabularyDialogListResponse =>
      _vocabularyDialogListDataModel;

  Future<void> fetchVocabularyDialogList(int vocabularyId) async {
    try {
      print(" -- $vocabularyId");
      final response =
          await _apiService.getVocabularyDialogList(vocaId: vocabularyId);

      _vocabularyDialogListDataModel =
          VocabularyDialogListDataModel.fromJson(response);
      print("Response from fetchVocabularyDialogList: ${response}");
      notifyListeners();
      // return response;
    } catch (error) {
      print('Error in fetchVocabularyDialogList: $error');
      throw Exception('Failed to load data. Check your network connection.');
    }
  }
}
