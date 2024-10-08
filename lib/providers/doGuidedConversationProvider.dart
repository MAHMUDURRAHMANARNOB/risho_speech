import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:risho_speech/models/doConversationDataModel.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:risho_speech/models/doGuidedConverationDataModel.dart';

import '../api/api_service.dart';

class DoGuidedConversationProvider extends ChangeNotifier {
  ApiService _apiService = ApiService();

  DoGuidedConversationDataModel? _doGuidedConversationDataModel;

  DoGuidedConversationDataModel? get guidedConversationResponse =>
      _doGuidedConversationDataModel;

  Future<Map<String, dynamic>> fetchGuidedConversationResponse(
    int userId,
    int conversationId,
    String? dialogId,
    File? audioFile,
    String? discussionTopic,
    String? discussTitle,
    String? isFemale,
    String? userName,
    int? dialogSeqNo,
  ) async {
    print(
        "inside fetchGuidedConversationResponse $userId $conversationId $dialogId $userName");
    try {
      // Use default audio file if audioFile is null
      // File selectedAudioFile = audioFile;

      final response = await _apiService.doGuidedConversation(
        userId: userId,
        conversationId: conversationId,
        dialogId: dialogId ?? "",
        audioFile: audioFile,
        discussionTopic: discussionTopic!,
        discussTitle: discussTitle!,
        isFemale: isFemale!,
        userName: userName!,
        dialogSeqNo: dialogSeqNo!,
      );
      if (response['errorcode'] == 200) {
        _doGuidedConversationDataModel =
            DoGuidedConversationDataModel.fromJson(response);

        print("Response from fetchGuidedConversationResponse: $response");
        notifyListeners();
        return response;
      } else {
        _doGuidedConversationDataModel = DoGuidedConversationDataModel(
          error: response['errorcode'],
          message: response['message'],
          convid: null,
          actorName: '',
          conversationEn: '',
          conversationBn: '',
          conversationAudioFile: '',
          seqNumber: null,
          isFirst: '',
          isLast: '',
          conversationDetails: '',
          discussionTopic: '',
          discusTitle: '',
          pronScore: null,
          accuracyScore: null,
          fluencyScore: null,
          completenessScore: null,
          prosodyScore: null,
          speechText: null,
          speechTextBn: null,
          fileLoc: null,
          dialogId: null,
          words: [],
        );
        notifyListeners();
        return response;
      }
    } catch (error) {
      print('Error in getGuidedConversationResponse: $error');
      throw Exception('Failed to load data. Check your network connection.');
    }
  }
}
