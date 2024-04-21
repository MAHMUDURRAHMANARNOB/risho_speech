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

  Future<File> _loadAssetAsFile(String assetPath) async {
    final ByteData data = await rootBundle.load(assetPath);
    final List<int> bytes = data.buffer.asUint8List();
    final Directory tempDir = await getTemporaryDirectory();
    final String tempPath = '${tempDir.path}/${assetPath.split('/').last}';
    final File file = File(tempPath);
    await file.writeAsBytes(bytes);
    return file;
  }

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
      if (response['error'] == 200) {
        _doGuidedConversationDataModel =
            DoGuidedConversationDataModel.fromJson(response);
        print("Response from fetchGuidedConversationResponse: $response");
        notifyListeners();
        return response;
      } else {
        _doGuidedConversationDataModel = DoGuidedConversationDataModel(
          error: response['error'],
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
          accuracyScore: null,
          fluencyScore: null,
          completenessScore: null,
          prosodyScore: null,
          speechText: null,
          speechTextBn: null,
          fileLoc: null,
          dialogId: null,
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
