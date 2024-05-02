import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:risho_speech/providers/VocabularyDialogListProvider.dart';
import 'package:risho_speech/providers/VocabularySentenceListProvider.dart';
import 'package:risho_speech/ui/colors.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

import '../../providers/vocabularyPracticeListProvider.dart';

class VocabularyPracticeScreenMobile extends StatefulWidget {
  final int categoryId;
  const VocabularyPracticeScreenMobile({super.key, required this.categoryId});

  @override
  State<VocabularyPracticeScreenMobile> createState() =>
      _VocabularyPracticeScreenMobileState();
}

class _VocabularyPracticeScreenMobileState
    extends State<VocabularyPracticeScreenMobile> {
  int currentIndex = 0;
  late bool isPlaying = false;
  bool _isRecording = false;

  File? audioFile;
  String? _audioPath;

  late AudioPlayer audioPlayer;
  late Record audioRecord;

  VocabularyPracticeProvider vocabularyPracticeProvider =
      VocabularyPracticeProvider();
  VocabularySentenceListProvider vocabularySentenceListProvider =
      VocabularySentenceListProvider();
  VocabularyDialogListProvider vocabularyDialogListProvider =
      VocabularyDialogListProvider();

  Future<void> startRecording() async {
    try {
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
          /*_conversationComponents.add(
            AIResponseBox(audioFile!, _dialogId, userName),
          );*/
        });
        // _isSuggestAnsActive = false;
        // suggestedAnswer = null;
      }
    } catch (e) {
      print("Error stop recording: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    audioRecord = Record();
    vocabularyPracticeProvider.fetchVocabularyPracticeList(
      widget.categoryId,
    );
  }

  @override
  void dispose() {
    audioRecord.dispose();
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    late int _vocabularyId;
    return Scaffold(
      appBar: AppBar(
        title: Text("Practice Vocabulary"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: FutureBuilder<void>(
                future: vocabularyPracticeProvider
                    .fetchVocabularyPracticeList(widget.categoryId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: SpinKitThreeBounce(
                        color: AppColors.primaryColor,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else {
                    if (vocabularyPracticeProvider.vocabularyPracticeResponse ==
                            null ||
                        vocabularyPracticeProvider
                            .vocabularyPracticeResponse!.vocaList.isEmpty) {
                      return Center(
                        child: Text('No vocabulary available.'),
                      );
                    } else {
                      final vocabList = vocabularyPracticeProvider
                          .vocabularyPracticeResponse!.vocaList;
                      if (vocabList.isEmpty) {
                        return Center(
                          child: Text('No vocabulary available.'),
                        );
                      } else {
                        final word = vocabList[currentIndex];
                        _vocabularyId = word.id;
                        return Column(
                          children: [
                            Card(
                              margin: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: Container(
                                padding: EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: 1,
                                        ),
                                        IconButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                          ),
                                          onPressed: () {
                                            Source urlSource =
                                                UrlSource(word.wordAudio);
                                            audioPlayer.play(urlSource);

                                            print(word.wordAudio);
                                          },
                                          icon: Icon(
                                            Icons.volume_up_rounded,
                                            color:
                                                AppColors.backgroundColorDark,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Container(
                                      width: double.infinity,
                                      child: Text(
                                        word.vocWord,
                                        style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Meaning: ",
                                        ),
                                        Text(
                                          word.englishMeaning,
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Bangla Meaning: ",
                                        ),
                                        Text(
                                          word.banglaMeaning,
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  AppColors.primaryCardColor,
                                            ),
                                            onPressed: currentIndex > 0
                                                ? () {
                                                    setState(() {
                                                      currentIndex--;
                                                    });
                                                  }
                                                : null,
                                            child: Text(
                                              "Prevous",
                                              style: TextStyle(
                                                color: currentIndex > 0
                                                    ? Colors.white
                                                    : Colors.grey,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 16),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  AppColors.primaryCardColor,
                                            ),
                                            onPressed: currentIndex <
                                                    vocabList.length - 1
                                                ? () {
                                                    setState(() {
                                                      currentIndex++;
                                                    });
                                                  }
                                                : null,
                                            child: Text(
                                              "Next",
                                              style: TextStyle(
                                                color: currentIndex <
                                                        vocabList.length - 1
                                                    ? Colors.white
                                                    : Colors.grey,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            /*Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          AppColors.primaryCardColor,
                                    ),
                                    onPressed: currentIndex > 0
                                        ? () {
                                            setState(() {
                                              currentIndex--;
                                            });
                                          }
                                        : null,
                                    child: Text(
                                      "Prevous",
                                      style: TextStyle(
                                        color: currentIndex > 0
                                            ? Colors.white
                                            : Colors.grey,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          AppColors.primaryCardColor,
                                    ),
                                    onPressed:
                                        currentIndex < vocabList.length - 1
                                            ? () {
                                                setState(() {
                                                  currentIndex++;
                                                });
                                              }
                                            : null,
                                    child: Text(
                                      "Next",
                                      style: TextStyle(
                                        color:
                                            currentIndex < vocabList.length - 1
                                                ? Colors.white
                                                : Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),*/
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      showModalBottomSheet<void>(
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                        context: context,
                                        showDragHandle: true,
                                        builder: (BuildContext context) =>
                                            DialogContainer(_vocabularyId),
                                      );
                                    },
                                    child: Text(
                                      "Dialog",
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      /*SentenceContainer(_vocabularyId);*/
                                      showModalBottomSheet<void>(
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                        context: context,
                                        showDragHandle: true,
                                        builder: (BuildContext context) =>
                                            SentenceContainer(_vocabularyId),
                                      );
                                    },
                                    child: Text(
                                      "Sentences",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }
                    }
                  }
                },
              ),
            ),
          ),
          /*Container(
            child: SingleChildScrollView(
              child:
            ),
          ),*/
          /*Bottom Control*/
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.primaryCardColor,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(80),
                topLeft: Radius.circular(80),
              ),
            ),
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: [
                /* SEND / VOICE */
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Flexible(
                      flex: 2,
                      child: AvatarGlow(
                        animate: _isRecording,
                        curve: Curves.fastOutSlowIn,
                        glowColor: AppColors.primaryColor,
                        duration: const Duration(milliseconds: 1000),
                        repeat: true,
                        glowRadiusFactor: 1,
                        child: Container(
                          margin: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
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
                              setState(() {});
                            },
                            icon: Container(
                              padding: EdgeInsets.all(20),
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
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget DialogContainer(int _vocabularyId) {
    return DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 1,
        builder: (_, controller) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0)),
              color: AppColors.ExpandedCourseCardColor,
            ),
            width: double.infinity,
            padding: EdgeInsets.all(10.0),
            child: FutureBuilder(
              future: vocabularyDialogListProvider
                  .fetchVocabularyDialogList(_vocabularyId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  // Assuming your VocabularyDialogListDataModel has a property named dialogList
                  final dialogList = vocabularyDialogListProvider
                      .vocabularyDialogListResponse?.dialogList;
                  print("hello ${dialogList?.length.toString()}");

                  if (dialogList == null || dialogList.isEmpty) {
                    return Center(
                      child: Text('No data available'),
                    );
                  } else {
                    return ListView.builder(
                      controller: controller,
                      shrinkWrap: true,
                      itemCount: dialogList.length,
                      itemBuilder: (context, index) {
                        final dialog = dialogList[index];
                        return ListTile(
                          title: Text(dialog.conversationEn ?? ''),
                          subtitle: Text(dialog.conversationBn ?? ''),
                          // Add any other properties you want to display
                        );
                      },
                    );
                  }
                }
              },
            ),
          );
        });
  }

  Widget SentenceContainer(int _vocabularyId) {
    return DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 1,
        builder: (_, controller) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0)),
              color: AppColors.ExpandedCourseCardColor,
            ),
            width: double.infinity,
            padding: EdgeInsets.all(10.0),
            child: FutureBuilder(
              future: vocabularySentenceListProvider
                  .fetchVocabularySentenceList(_vocabularyId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  // Assuming your VocabularyDialogListDataModel has a property named dialogList
                  final sentenceList = vocabularySentenceListProvider
                      .vocabularySentenceListResponse?.sentenceList;
                  print("hello ${sentenceList?.length.toString()}");

                  if (sentenceList == null || sentenceList.isEmpty) {
                    return Center(
                      child: Text('No data available'),
                    );
                  } else {
                    return ListView.builder(
                      controller: controller,
                      shrinkWrap: true,
                      itemCount: sentenceList.length,
                      itemBuilder: (context, index) {
                        final sentence = sentenceList[index];
                        return ListTile(
                          title: Text(sentence.vocaSentence ?? '--'),
                          subtitle: Text(sentence.vocaSentenceBn ?? '--'),
                          // Add any other properties you want to display
                        );
                      },
                    );
                  }
                }
              },
            ),
          );
        });
  }
}
