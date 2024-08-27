import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../api/api_service.dart';
import '../models/IeltsVocabularyCategoryListDataModel.dart';
import '../models/ieltsVocabularyListDataModel.dart';

class IeltsVocabularyListProvider with ChangeNotifier {
  ApiService _apiService = ApiService();
  bool _isLoading = false;
  String? _errorMessage;
  IeltsVocabularyListDataModel? _ieltsVocabularyListDataModel;

  IeltsVocabularyListDataModel? get vocabularyCategories =>
      _ieltsVocabularyListDataModel;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  Future<void> fetchIeltsVocabularyList(
      int vocabularyCategoryId, String isIdioms) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.getIeltsVocabularyList(
          vocabularyCategoryId, isIdioms);
      _ieltsVocabularyListDataModel =
          IeltsVocabularyListDataModel.fromJson(response);
      notifyListeners();
      debugPrint(response.toString());
    } catch (e) {
      _errorMessage = 'An error occurred: $e';
      print('Error in fetchIeltsVocabularyList: $_errorMessage');
      throw Exception('Failed to load data. Check your network connection.');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
