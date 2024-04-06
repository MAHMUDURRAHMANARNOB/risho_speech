import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:risho_speech/models/spokenLessonListDataModel.dart';
import 'package:risho_speech/models/validateSpokenSentenceDataModel.dart';

import '../api/api_service.dart';

class SpokenLessonListProvider extends ChangeNotifier {
  ApiService _apiService = ApiService();

  SpokenLessonListDataModel? _spokenLessonListDataModel;

  SpokenLessonListDataModel? get spokenLessonListResponse =>
      _spokenLessonListDataModel;

  Future<void> fetchSpokenLessonListResponse() async {
    print("inside fetchSpokenLessonListResponse");
    try {
      final response = await _apiService.getSpokenLessonList();
      _spokenLessonListDataModel =
          SpokenLessonListDataModel.fromJson(response['lessonList']);
      print(
          "Response from fetchSpokenLessonListResponse: ${response['lessonList']}");
      notifyListeners();
    } catch (error) {
      print('Error in getSpokenLessonListResponse: $error');
      throw Exception('Failed to load data. Check your network connection.');
    }
  }
}
