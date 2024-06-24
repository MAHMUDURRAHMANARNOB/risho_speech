import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import 'package:record/record.dart';
import 'package:risho_speech/screens/Common/RecordingButton.dart';
import '../../models/vocabularyPronunciationDataModel.dart';
import '../../providers/auth_provider.dart';
import '../../providers/vocabularyPracticeListProvider.dart';
import '../../providers/vocabularyPronunciationProvider.dart';
import '../../ui/colors.dart';
import '../packages_screen.dart';

class VocabularyPracticeScreen extends StatefulWidget {
  final String wordText;
  final String categoryName;

  const VocabularyPracticeScreen(
      {super.key, required this.wordText, required this.categoryName});

  @override
  State<VocabularyPracticeScreen> createState() =>
      _VocabularyPracticeScreenState();
}

class _VocabularyPracticeScreenState extends State<VocabularyPracticeScreen> {
  late int _vocabularyId;
  int currentIndex = 0;
  late bool isPlaying = false;
  bool _isRecording = false;
  List<Widget> _conversationComponents = [];

  File? audioFile;
  String? _audioPath;

  late String _aiDialog = '';
  late String _aiDialogTranslation = '';
  late double _accuracyScore = 0.0;
  late double _fluencyScore = 0.0;
  late double _completenessScore = 0.0;
  late double _prosodyScore = 0.0;
  late String _userText = '';
  late String _userTranslation = '';
  late List<Word>? _words = [];
  late List<Phoneme>? _phoneme = [];

  late AuthProvider authController =
      Provider.of<AuthProvider>(context, listen: false);

  ValidatePronunciationProvider validatePronunciationProvider =
      ValidatePronunciationProvider();

  late AudioPlayer audioPlayer;
  late Record audioRecord;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    audioRecord = Record();
  }

  @override
  void dispose() {
    audioRecord.dispose();
    audioPlayer.dispose();
    super.dispose();
  }

  late String userName = authController.user!.username ?? "username";
  late int userId = authController.user!.id ?? 123;

  Future<void> startRecording() async {
    try {
      _conversationComponents.clear();
      if (await audioRecord.hasPermission()) {
        await audioRecord.start();
        setState(() {
          _isRecording = true;
        });
      }
    } catch (e) {
      print("Error start recording: $e");
    }
  }

  Future<void> stopRecording() async {
    try {
      if (await audioRecord.hasPermission()) {
        String? path = await audioRecord.stop();
        setState(() {
          _isRecording = false;
          _audioPath = path;
          audioFile = File(_audioPath!);
          print(_audioPath);

          setState(() {
            _conversationComponents.add(
              AIResponseBox(
                  audioFile!, widget.wordText, userId, widget.categoryName),
            );
          });
        });
      }
    } catch (e) {
      print("Error stop recording: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryCardColor,
        onPressed: () {
          showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              return const AlertDialog(
                title: Text("Note"),
                content: Text("Audio Minutes are required for practicing."),
              );
            },
          );
        },
        child: Icon(
          Icons.question_mark_outlined,
          color: AppColors.primaryColor,
        ),
      ),
      appBar: AppBar(
        title: Text("Vocabulary"),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.wordText,
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            AvatarGlow(
              animate: _isRecording,
              curve: Curves.fastOutSlowIn,
              glowColor: AppColors.primaryColor,
              duration: const Duration(milliseconds: 1000),
              repeat: true,
              glowRadiusFactor: 1,
              child: Container(
                margin: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
                child: IconButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isRecording == false
                        ? Colors.white
                        : AppColors.primaryColor,
                    elevation: 4,
                  ),
                  onPressed: () async {
                    // Add your logic to send the message
                    if (!_isRecording) {
                      await startRecording();
                    } else {
                      await stopRecording();
                    }
                  },
                  icon: Container(
                    padding: const EdgeInsets.all(20),
                    child: Icon(
                      _isRecording == false
                          ? Icons.keyboard_voice_rounded
                          : Icons.stop_rounded,
                      color: _isRecording == false
                          ? AppColors.primaryColor
                          : Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _conversationComponents.length,
                itemBuilder: (context, index) {
                  return _conversationComponents[index];
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget AIResponseBox(
      File? audio, String? wordText, int userId, String categoryName) {
    // print(sessionId);
    return FutureBuilder<void>(
        future: validatePronunciationProvider
            .fetchValidateVocabPronunciationResponse(
          userId,
          wordText!,
          audio,
          categoryName,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SpinKitThreeInOut(
              color: AppColors.primaryColor,
            ); // Loading state
          } else if (snapshot.hasError) {
            return Container(
              margin: const EdgeInsets.all(5.0),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: AppColors.primaryCardColor,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      "Sorry: Server error",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            int errorCode = validatePronunciationProvider
                .validateVocabPronunciationResponse!.error;
            print(errorCode);
            if (errorCode == 200) {
              _accuracyScore = validatePronunciationProvider
                      .validateVocabPronunciationResponse!.accuracyScore ??
                  0.0;
              _fluencyScore = validatePronunciationProvider
                      .validateVocabPronunciationResponse!.fluencyScore ??
                  0.0;
              _completenessScore = validatePronunciationProvider
                      .validateVocabPronunciationResponse!.completenessScore ??
                  0.0;
              _prosodyScore = validatePronunciationProvider
                      .validateVocabPronunciationResponse!.prosodyScore ??
                  0.0;

              _words = validatePronunciationProvider
                  .validateVocabPronunciationResponse?.words;

              int index = 0;

              if (_words != null && index >= 0 && index < _words!.length) {
                _phoneme = _words![index].phonemes;
              } else {
                _phoneme = null; // Handle index out of bounds or null response
              }

              _userText = validatePronunciationProvider
                      .validateVocabPronunciationResponse!.speechText ??
                  "";
              _userTranslation = validatePronunciationProvider
                      .validateVocabPronunciationResponse!.speechTextbn ??
                  "Not Found";
              print("userText: $_userText");

              return SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _userText,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/accuracy.png",
                            width: 20,
                            height: 20,
                          ),
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Accuracy Score:"),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 8,
                                        child: LinearProgressIndicator(
                                          value: _accuracyScore / 100,
                                          // value should be between 0 and 1
                                          backgroundColor: Colors.grey[300],
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  AppColors.primaryColor),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                            "${_accuracyScore.toString()}%"),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/fluency.png",
                            width: 20,
                            height: 20,
                          ),
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Fluency Score:"),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 8,
                                        child: LinearProgressIndicator(
                                          value: _fluencyScore / 100,
                                          // value should be between 0 and 1
                                          backgroundColor: Colors.grey[300],
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  AppColors.primaryColor),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                            "${_fluencyScore.toString()}%"),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/solution.png",
                            width: 20,
                            height: 20,
                          ),
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Completeness Score:"),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 8,
                                        child: LinearProgressIndicator(
                                          value: _completenessScore / 100,
                                          // value should be between 0 and 1
                                          backgroundColor: Colors.grey[300],
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  AppColors.primaryColor),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                            "${_completenessScore.toString()}%"),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/prosody.png",
                            width: 20,
                            height: 20,
                          ),
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Prosody Score:"),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 8,
                                        child: LinearProgressIndicator(
                                          value: _prosodyScore / 100,
                                          // value should be between 0 and 1
                                          backgroundColor: Colors.grey[300],
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  AppColors.primaryColor),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                            "${_prosodyScore.toString()}%"),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      /*SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columnSpacing: 10,
                        columns: [
                          DataColumn(label: Text('Word')),
                          DataColumn(label: Text('Accuracy Score')),
                          DataColumn(label: Text('Comments')),
                        ],
                        rows: _words?.map((word) {
                              String errorType = word.errorType ?? '';
                              if (word.errorType == "None") {
                                errorType = "Perfect";
                              } else {
                                errorType = word.errorType ?? '';
                              }
                              return DataRow(
                                cells: [
                                  DataCell(
                                    Text(word.word ?? ""),
                                  ),
                                  DataCell(
                                    Text(word.accuracyScore.toString() ?? ""),
                                  ),
                                  DataCell(
                                    Text(
                                      errorType,
                                      style: TextStyle(
                                          color: errorType != "Perfect"
                                              ? AppColors.secondaryColor
                                              : AppColors.primaryColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              );
                            }).toList() ??
                            [],
                      ),
                    ),*/
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columnSpacing: 10,
                          columns: [
                            DataColumn(label: Text('Phoneme')),
                            DataColumn(label: Text('Accuracy Score')),
                            // DataColumn(label: Text('Comments')),
                          ],
                          rows: _phoneme?.map((word) {
                                return DataRow(
                                  cells: [
                                    DataCell(
                                      Text(word.phoneme.toString() ?? ""),
                                    ),
                                    DataCell(
                                      Text(word.accuracyScore.toString() ?? ""),
                                    ),
                                    /*DataCell(
                            Text(
                              errorType,
                              style: TextStyle(
                                  color: errorType != "Perfect"
                                      ? AppColors.secondaryColor
                                      : AppColors.primaryColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),*/
                                  ],
                                );
                              }).toList() ??
                              [],
                        ),
                      ),
                    ],
                  ),
                ),
              );
              // updateLatestQuestion(aiDialog);
              // return buildAiResponse(context, snapshot);
            } else if (errorCode == 201) {
              return Container(
                margin: const EdgeInsets.all(5.0),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: AppColors.primaryCardColor,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        "Sorry: ${validatePronunciationProvider.validateVocabPronunciationResponse!.message}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryCardColor),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const PackagesScreen()),
                          );
                        },
                        child: const Text(
                          "Purchase Minutes",
                          style: TextStyle(
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return const CircularProgressIndicator();
            }
          }
        });
  }
}
