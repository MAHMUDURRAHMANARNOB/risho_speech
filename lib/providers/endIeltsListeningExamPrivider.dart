import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api/api_service.dart';
import '../models/ListeningAudioQuestionResponseDataModel.dart';
import '../models/listeningPracticeBandScoreDataModel.dart';

class EndIeltsListeningProvider with ChangeNotifier {
  ApiService _apiService = ApiService();
  ListeningPracticeBandScoreDataModel? _listeningPracticeBandScoreDataModel;
  bool _isLoading = false;
  String? _errorMessage;

  ListeningPracticeBandScoreDataModel?
      get _listeningPracticeBandScoreResponse =>
          _listeningPracticeBandScoreDataModel;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  Future<Map<String, dynamic>> endIeltsListeningExam({
    required int userId,
    required String? ansJson,
    required int? examinationId,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    // final url = 'your_base_url_here/startIELTSListeningExam/';
    print("inside endIeltsListeningExam $userId ,$ansJson, $examinationId");
    try {
      final response = await _apiService.endIeltsListeningExam(
        userId: userId,
        ansJson: ansJson ?? "",
        examinationId: examinationId,
      );
      if (response['errorcode'] == 200) {
        _listeningPracticeBandScoreDataModel =
            ListeningPracticeBandScoreDataModel.fromJson(response);

        // print("Response from ListeningAudioQuestionResponse: $response");
        _isLoading = false;
        notifyListeners();
        return response;
      }
      /*if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        _audioQuestionResponse = AudioQuestionResponse.fromJson(data);
      } else {
        _errorMessage = 'Failed to load data: ${response.statusCode}';
      }*/
      else {
        /*_listeningaudioquestionresponsedatamodel =
            Listeningaudioquestionresponsedatamodel(
          errorCode: response['errorcode'],
          message: response['message'],
          audioFile: '',
          question: '',
          examId: null,
        );*/
        notifyListeners();
        return response;
      }
    } catch (e) {
      _errorMessage = e.toString();
      print('Error in endIeltsListeningExam: ${e.toString()}');
      return {
        'errorcode': 500,
        'message': 'Error: $e',
      };
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
