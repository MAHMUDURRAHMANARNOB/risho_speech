import 'dart:io';
import 'package:flutter/material.dart';
import '../api/api_service.dart';
import '../models/speakingExamDataModel.dart';

class IeltsSpeakingExamProvider extends ChangeNotifier {
  ApiService _apiService = ApiService();

  SpeakingExamDataModel? _examResponse;

  SpeakingExamDataModel? get examResponse => _examResponse;

  Future<Map<String, dynamic>> fetchIeltsSpeakingExam({
    required int userId,
    required int? examinationId,
    required int examStage,
    required File? audioFile,
    required String? isFemale,
  }) async {
    print(
        "Fetching IELTS Speaking Exam: $userId, $examStage, $examinationId, $isFemale");

    try {
      final response = await _apiService.getIeltsSpeakingExam(
        userId: userId,
        examinationId: examinationId,
        examStage: examStage,
        audioFile: audioFile,
        isFemale: isFemale,
      );
      print(response['errorcode']);

      if (response['errorcode'] == 200) {
        _examResponse = SpeakingExamDataModel.fromJson(response);
        print("Response from fetchIeltsSpeakingExam: $response");
        notifyListeners();
        return response;
      } else {
        _examResponse = SpeakingExamDataModel(
          errorCode: response['errorcode'],
          message: response['message'],
          examId: response['examid'] ?? 0,
          aiDialogAudio: response['AIDialoagAudio'] ?? '',
          examStage: response['examStage'] ?? 0,
          cueCardTopics: response['cuecardtopics'] ?? '',
          isFemale: response['isFemale'] ?? '',
          report: response['report'],
        );
        notifyListeners();
        return response;
      }
    } catch (error) {
      print('Error in fetchIeltsSpeakingExam: $error');
      throw Exception('Failed to load data. Check your network connection.');
    }
  }
}
