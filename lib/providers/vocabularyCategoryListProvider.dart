import 'package:flutter/material.dart';
import 'package:risho_speech/api/api_service.dart';

import '../models/vocabularyCategoryListDataModel.dart';

class VocabularyCategoryListProvider with ChangeNotifier {
  ApiService _apiService = ApiService();

  VocaCategoryDataModel? _vocaCategoryDataModel;
  VocaCategoryDataModel? get vocabularyCategoryResponse =>
      _vocaCategoryDataModel;

  Future<void> fetchVocabularyCategoryList() async {
    try {
      final response = await _apiService.getVocabularyCategoryList();
      _vocaCategoryDataModel = VocaCategoryDataModel.fromJson(response);
      print("Response from fetchVocabularyCategoryList: ${response}");
      notifyListeners();
    } catch (error) {
      print('Error in fetchVocabularyCategoryList: $error');
      throw Exception('Failed to load data. Check your network connection.');
    }
  }
}
