import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../api/api_service.dart';
import '../models/IeltsVocabularyCategoryListDataModel.dart';

class IeltsVocabularyCategoryListProvider with ChangeNotifier {
  ApiService _apiService = ApiService();

  // List<VocaCat> _vocabularyCategories = [];
  bool _isLoading = false;
  String? _errorMessage;
  IeltsVocabularyCategoryListDataModel? _ieltsVocabularyCategoryListDataModel;

  IeltsVocabularyCategoryListDataModel? get vocabularyCategories =>
      _ieltsVocabularyCategoryListDataModel;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  Future<void> fetchIeltsVocabularyCategoryList(int topicCategory) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response =
          await _apiService.getIeltsVocabularyCategoryList(topicCategory);

      /*if (response.statusCode == 200) {
        var finalResponse = Utf8Decoder().convert(response.bodyBytes);
        var jsonResponse = json.decode(finalResponse);
        IeltsVocabularyCategoryListDataModel dataModel =
            IeltsVocabularyCategoryListDataModel.fromJson(jsonResponse);
        _vocabularyCategories = dataModel.vocaCatList;
      } else {
        _errorMessage = 'Failed to load vocabulary categories';
      }*/
      _ieltsVocabularyCategoryListDataModel =
          IeltsVocabularyCategoryListDataModel.fromJson(response);
      notifyListeners();
      debugPrint(response.toString());
    } catch (e) {
      _errorMessage = 'An error occurred: $e';
      print('Error in fetchVocabularyCategoryList: $_errorMessage');
      throw Exception('Failed to load data. Check your network connection.');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
