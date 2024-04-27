import 'dart:io';

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

  CallConversationDataModel? _callConversationDataModel;

  CallConversationDataModel? get callConversationResponse =>
      _callConversationDataModel;

  Future<Map<String, dynamic>> fetchCallConversationResponse(
    int userId,
    int agentId,
    String? sessionId,
    File? audioFile,
    String? userName,
  ) async {
    print(
        "inside fetchCallConversationResponse $userId $agentId $sessionId $userName");
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

        print("Response from fetchGuidedConversationResponse: $response");
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
          aiDialogAudio: '',
          userText: '',
          userTextBn: '',
          userAudio: '',
          isFemale: '',
        );
        notifyListeners();
        return response;
      }
    } catch (error) {
      print('Error in fetchCallConversationResponse: $error');
      throw Exception('Failed to load data. Check your network connection.');
    }
  }
}
