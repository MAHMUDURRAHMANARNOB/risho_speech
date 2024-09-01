import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import '../api/api_service.dart';
import '../models/speakingExamDataModel.dart';

class IeltsSpeakingExamProvider extends ChangeNotifier {
  ApiService _apiService = ApiService();

  SpeakingExamDataModel? _examResponse;

  AudioPlayer _audioPlayer = AudioPlayer();

  bool _isAiSaying = false;
  bool _isAiAnalyging = false;
  bool _isAiWaiting = false;

  SpeakingExamDataModel? get examResponse => _examResponse;

  bool get isAiSaying => _isAiSaying;

  bool get isAiAnalyging => _isAiAnalyging;

  bool get isAiWaiting => _isAiWaiting;

  Future<Map<String, dynamic>> fetchIeltsSpeakingExam({
    required int userId,
    required int? examinationId,
    required int examStage,
    required File? audioFile,
    required String? isFemale,
  }) async {
    print(
        "Fetching IELTS Speaking Exam: $userId, $examStage, $examinationId, $isFemale");
    if (audioFile != null) {
      print("notnull");
    } else {
      print("nullnull");
    }
    _isAiWaiting = false;
    _isAiAnalyging = true; // Set to true when API call is in progress
    notifyListeners();
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
        _isAiAnalyging = false;
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
        _isAiAnalyging = false; // Set to false when API call fails
        _isAiWaiting = true;
        notifyListeners();
        notifyListeners();
        return response;
      }
    } catch (error) {
      _isAiAnalyging = false; // Set to false when API call fails
      _isAiWaiting = true;
      notifyListeners();
      print('Error in fetchIeltsSpeakingExam: $error');
      throw Exception('Failed to load data. Check your network connection.');
    }
  }

  Future<void> playAudioFromURL(String url) async {
    _isAiWaiting = false;
    _isAiSaying = true;
    notifyListeners();
    Source uri = UrlSource(url);
    await _audioPlayer.play(uri);
    _audioPlayer.onPlayerComplete.listen((_) {
      _isAiSaying = false; // Set to false when audio playback is complete
      _isAiWaiting = true;
      notifyListeners();
    });
  }
}
