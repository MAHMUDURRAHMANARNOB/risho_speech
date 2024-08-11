import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api/api_service.dart';
import '../models/ListeningAudioQuestionResponseDataModel.dart';

class IeltsListeningProvider with ChangeNotifier {
  ApiService _apiService = ApiService();
  Listeningaudioquestionresponsedatamodel?
      _listeningaudioquestionresponsedatamodel;
  bool _isLoading = false;
  String? _errorMessage;

  Listeningaudioquestionresponsedatamodel? get listeningAudioQuestionResponse =>
      _listeningaudioquestionresponsedatamodel;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  Future<Map<String, dynamic>> getIeltsListeningExam({
    required int userId,
    required int listeningPart,
    required int tokenUsed,
    required String? ansJson,
    required int? examinationId,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    // final url = 'your_base_url_here/startIELTSListeningExam/';
    print("inside getIeltsListeningExam $userId ");
    try {
      final response = await _apiService.getIeltsListeningExam(
        userId: userId,
        listeningPart: listeningPart,
        tokenUsed: tokenUsed,
        ansJson: ansJson ?? "",
        examinationId: examinationId,
      );
      if (response['errorcode'] == 200) {
        _listeningaudioquestionresponsedatamodel =
            Listeningaudioquestionresponsedatamodel.fromJson(response);

        print("Response from ListeningAudioQuestionResponse: $response");
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
        _listeningaudioquestionresponsedatamodel =
            Listeningaudioquestionresponsedatamodel(
          errorCode: response['errorcode'],
          message: response['message'],
          audioFile: '',
          question: '',
          examId: null,
        );
        notifyListeners();
        return response;
      }
    } catch (e) {
      _errorMessage = e.toString();
      print('Error in Listeningaudioquestionresponse: ${e.toString()}');
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
