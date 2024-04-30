import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:risho_speech/models/callAndConversationDataModel.dart';
import 'package:risho_speech/models/doConversationDataModel.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:risho_speech/models/doGuidedConverationDataModel.dart';

import '../api/api_service.dart';

class CallConversationProvider extends ChangeNotifier {
  ApiService _apiService = ApiService();
  AudioPlayer _audioPlayer = AudioPlayer();

  bool _isAiSaying = false;
  bool _isAiAnalyging = false;
  bool _isAiWaiting = false;

  CallConversationDataModel? _callConversationDataModel;

  CallConversationDataModel? get callConversationResponse =>
      _callConversationDataModel;

  bool get isAiSaying => _isAiSaying;
  bool get isAiAnalyging => _isAiAnalyging;
  bool get isAiWaiting => _isAiWaiting;

  Future<Map<String, dynamic>> fetchCallConversationResponse(
    int userId,
    int agentId,
    String? sessionId,
    File? audioFile,
    String? userName,
  ) async {
    print(
        "inside fetchCallConversationResponse $userId $agentId $sessionId $userName");
    _isAiWaiting = false;
    _isAiAnalyging = true; // Set to true when API call is in progress
    notifyListeners();
    try {
      // Use default audio file if audioFile is null
      // File selectedAudioFile = audioFile;

      final response = await _apiService.callConversation(
        userId: userId,
        agentId: agentId,
        sessionId: sessionId ?? "",
        audioFile: audioFile,
        userName: userName!,
      );
      if (response['errorcode'] == 200) {
        _callConversationDataModel =
            CallConversationDataModel.fromJson(response);

        // Play the received audio
        if (_callConversationDataModel?.aiDialogAudio != null) {
          playAudioFromURL(_callConversationDataModel!.aiDialogAudio!);
        }

        print("Response from fetchGuidedConversationResponse: $response");
        _isAiAnalyging = false; // Set to false when API call is complete
        // _isAiWaiting = true; // Set to false when API call is complete

        notifyListeners();
        return response;
      } else {
        _callConversationDataModel = CallConversationDataModel(
          errorCode: response['error'],
          message: response['message'],
          sessionID: '',
          accuracyScore: null,
          fluencyScore: null,
          completenessScore: null,
          prosodyScore: null,
          wordScores: [],
          aiDialog: '',
          aiDialogBn: '',
          aiDialogAudio: '',
          userText: '',
          userTextBn: '',
          userAudio: '',
          isFemale: '',
        );
        _isAiAnalyging = false; // Set to false when API call fails
        _isAiWaiting = true;
        notifyListeners();
        return response;
      }
    } catch (error) {
      print('Error in fetchCallConversationResponse: $error');
      _isAiAnalyging = false; // Set to false when API call fails
      _isAiWaiting = true;
      notifyListeners();
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
