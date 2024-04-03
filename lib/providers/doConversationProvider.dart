import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:risho_speech/models/doConversationDataModel.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;

import '../api/api_service.dart';

class DoConversationProvider extends ChangeNotifier {
  ApiService _apiService = ApiService();

  DoConversationDataModel? _doConversationDataModel;

  DoConversationDataModel? get conversationResponse => _doConversationDataModel;

  Future<File> _loadAssetAsFile(String assetPath) async {
    final ByteData data = await rootBundle.load(assetPath);
    final List<int> bytes = data.buffer.asUint8List();
    final Directory tempDir = await getTemporaryDirectory();
    final String tempPath = '${tempDir.path}/${assetPath.split('/').last}';
    final File file = File(tempPath);
    await file.writeAsBytes(bytes);
    return file;
  }

  Future<Map<String, dynamic>> fetchConversationResponse(
    int userId,
    int conversationId,
    String? sessionId,
    File? audioFile,
    String? discussionTopic,
    String? discussTitle,
    String? isFemale,
    String? userName,
  ) async {
    print("inside fetchConversationResponse $userId $conversationId");
    try {
      // Use default audio file if audioFile is null
      File selectedAudioFile =
          audioFile ?? await _loadAssetAsFile('assets/audio/sample.wav');
      ;

      Map<String, dynamic> response = await _apiService.doConversation(
        userId: userId,
        conversationId: conversationId,
        sessionId: sessionId ?? '',
        audioFile: selectedAudioFile,
        discussionTopic: discussionTopic!,
        discussTitle: discussTitle!,
        isFemale: isFemale!,
        userName: userName!,
      );
      _doConversationDataModel = DoConversationDataModel.fromJson(response);
      print("Response from fetchConversationResponse: $response");
      notifyListeners();
      return response;
    } catch (error) {
      print('Error in getConversationResponse: $error');
      throw Exception('Failed to load data. Check your network connection.');
    }
  }
}
