import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:risho_speech/providers/VocabularyDialogListProvider.dart';
import 'package:risho_speech/providers/VocabularySentenceListProvider.dart';
import 'package:risho_speech/screens/Mobile/VocabularyPracticeScreenDedicated.dart';
import 'package:risho_speech/ui/colors.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

import '../../models/vocabularyPronunciationDataModel.dart';
import '../../providers/auth_provider.dart';
import '../../providers/vocabularyPracticeListProvider.dart';
import '../../providers/vocabularyPronunciationProvider.dart';
import '../Common/RecordingButton.dart';

class VocabularyPracticeScreenMobile extends StatefulWidget {
  final int categoryId;
  final String categoryName;
  const VocabularyPracticeScreenMobile(
      {super.key, required this.categoryId, required this.categoryName});

  @override
  State<VocabularyPracticeScreenMobile> createState() =>
      _VocabularyPracticeScreenMobileState();
}

class _VocabularyPracticeScreenMobileState
    extends State<VocabularyPracticeScreenMobile> {
  late int _vocabularyId;
  int currentIndex = 0;
  late bool isPlaying = false;
  bool _isRecording = false;

  File? audioFile;
  String? _audioPath;

  late AudioPlayer audioPlayer;
  late Record audioRecord;

  /*Regular Changing Variables*/
  /*Regular changing variables*/
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
  VocabularyPracticeProvider vocabularyPracticeProvider =
      VocabularyPracticeProvider();
  VocabularySentenceListProvider vocabularySentenceListProvider =
      VocabularySentenceListProvider();
  VocabularyDialogListProvider vocabularyDialogListProvider =
      VocabularyDialogListProvider();

  ValidatePronunciationProvider validatePronunciationProvider =
      ValidatePronunciationProvider();

  late String userName = authController.user!.username ?? "username";
  late int userId = authController.user!.id ?? 123;
  late String _wordText = '';

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
          // AIResponseBox(audioFile!, _wordText, userId, widget.categoryName);
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

  Future<void> _fetchVocabularyPracticeList() async {
    await vocabularyPracticeProvider
        .fetchVocabularyPracticeList(widget.categoryId);
  }

  @override
  Widget build(BuildContext context) {
    // late int _vocabularyId;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Practice Vocabulary"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          buildVocabularyPracticeWidget(context),
          Container(
            padding: EdgeInsets.all(20.0),
            margin: EdgeInsets.all(20.0),
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => VocabularyPracticeScreen(
                            wordText: _wordText,
                            categoryName: widget.categoryName,
                          )),
                );
              },
              child: Container(
                padding: EdgeInsets.all(20.0),
                child: const Text(
                  "Practice",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /*Vocabulary Widget*/
  Widget buildVocabularyPracticeWidget(BuildContext context) {
    return Expanded(
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
                  _wordText = word.vocWord;
                  Source urlSource = UrlSource(word.wordAudio);
                  audioPlayer.play(urlSource);
                  return Column(
                    children: [
                      Card(
                        color: AppColors.primaryCardColor,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const SizedBox(
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
                                    icon: const Icon(
                                      Icons.volume_up_rounded,
                                      color: AppColors.backgroundColorDark,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
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
                              const SizedBox(
                                height: 10.0,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Meaning: ",
                                  ),
                                  Text(
                                    word.englishMeaning,
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Bangla Meaning: ",
                                  ),
                                  Text(
                                    word.banglaMeaning,
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                              /*Next Previous buttons*/
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    /*Previous Button*/
                                    Expanded(
                                      flex: 1,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: currentIndex > 0
                                              ? AppColors.secondaryColor
                                                  .withOpacity(0.3)
                                              : Colors.grey,
                                        ),
                                        onPressed: currentIndex > 0
                                            ? () {
                                                setState(() {
                                                  currentIndex--;
                                                });
                                              }
                                            : null,
                                        child: Text(
                                          "Previous",
                                          style: TextStyle(
                                            color: currentIndex > 0
                                                ? Colors.white
                                                : Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    /*Next button*/
                                    Expanded(
                                      flex: 1,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: currentIndex <
                                                  vocabList.length - 1
                                              ? AppColors.primaryColor
                                                  .withOpacity(0.3)
                                              : Colors.grey,
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
                                            color: currentIndex <
                                                    vocabList.length - 1
                                                ? Colors.white
                                                : Colors.grey,
                                          ),
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

                      /*See dialogue and Make Sentences*/
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            /*See dialogue*/
                            ElevatedButton(
                              onPressed: () {
                                showModalBottomSheet<void>(
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  context: context,
                                  // showDragHandle: true,
                                  builder: (BuildContext context) =>
                                      DialogContainer(_vocabularyId),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryCardColor,
                                padding: EdgeInsets.all(15.0),
                              ),
                              child: const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "See Dialogue",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_circle_right_rounded,
                                    size: 30,
                                    color: AppColors.primaryColor,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            /*Make Sentences*/
                            ElevatedButton(
                              onPressed: () {
                                showModalBottomSheet<void>(
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  context: context,
                                  // showDragHandle: true,
                                  builder: (BuildContext context) =>
                                      SentenceContainer(_vocabularyId),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryCardColor,
                                padding: const EdgeInsets.all(15.0),
                              ),
                              child: const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Make Sentences",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_circle_right_rounded,
                                    size: 30,
                                    color: AppColors.primaryColor,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
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
    );
  }

  /*Bottom Scrollable container  for Dialogs*/
  Widget DialogContainer(int _vocabularyId) {
    return DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 1,
        builder: (_, controller) {
          return Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0)),
              color: AppColors.ExpandedCourseCardColor,
            ),
            width: double.infinity,
            padding: const EdgeInsets.all(10.0),
            child: FutureBuilder(
              future: vocabularyDialogListProvider
                  .fetchVocabularyDialogList(_vocabularyId),
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
                  // Assuming your VocabularyDialogListDataModel has a property named dialogList
                  final dialogList = vocabularyDialogListProvider
                      .vocabularyDialogListResponse?.dialogList;
                  // print("hello ${dialogList?.length.toString()}");

                  if (dialogList == null || dialogList.isEmpty) {
                    return const Center(
                      child: Text('No data available'),
                    );
                  } else {
                    return SingleChildScrollView(
                      controller: controller,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "A Conversation between ${dialogList[0].actorName} and ${dialogList[1].actorName}",
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            // controller: controller,
                            shrinkWrap: true,
                            itemCount: dialogList.length,
                            itemBuilder: (context, index) {
                              final dialog = dialogList[index];
                              final isEven = index % 2 == 0;
                              final ganderImage =
                                  dialogList[index].actorGender == "M"
                                      ? "assets/images/man_chat.png"
                                      : "assets/images/woman_chat.png";
                              return GestureDetector(
                                onTap: () {
                                  Source url =
                                      UrlSource(dialog.conversationAudioFile!);
                                  audioPlayer.play(url);
                                },
                                child: Container(
                                  padding: const EdgeInsets.fromLTRB(
                                      5.0, 5.0, 5.0, 0.0),
                                  margin: const EdgeInsets.fromLTRB(
                                      5.0, 5.0, 5.0, 5.0),
                                  decoration: BoxDecoration(
                                      color: isEven
                                          ? Colors.white70
                                          : AppColors.primaryColor,
                                      borderRadius: isEven
                                          ? const BorderRadius.only(
                                              topRight: Radius.circular(12.0),
                                              topLeft: Radius.circular(12.0),
                                              bottomRight:
                                                  Radius.circular(12.0),
                                              bottomLeft: Radius.circular(0.0))
                                          : const BorderRadius.only(
                                              topRight: Radius.circular(12.0),
                                              topLeft: Radius.circular(12.0),
                                              bottomRight: Radius.circular(0.0),
                                              bottomLeft:
                                                  Radius.circular(12.0))),
                                  child: Column(
                                    crossAxisAlignment: isEven
                                        ? CrossAxisAlignment.start
                                        : CrossAxisAlignment.end,
                                    children: [
                                      isEven
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Image.asset(
                                                  ganderImage,
                                                  width: 30,
                                                  height: 30,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  dialog.actorName ?? '',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: isEven
                                                        ? Colors.black
                                                        : Colors.white,
                                                  ),
                                                  textAlign: isEven
                                                      ? TextAlign.start
                                                      : TextAlign.end,
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                    Source url = UrlSource(dialog
                                                        .conversationAudioFile!);
                                                    audioPlayer.play(url);
                                                  },
                                                  icon: Icon(
                                                    Icons.play_arrow,
                                                    color: AppColors
                                                        .backgroundColorDark,
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                IconButton(
                                                  onPressed: () {
                                                    Source url = UrlSource(dialog
                                                        .conversationAudioFile!);
                                                    audioPlayer.play(url);
                                                  },
                                                  icon: Icon(
                                                    Icons.play_arrow,
                                                    color: AppColors
                                                        .backgroundColorDark,
                                                  ),
                                                ),
                                                Text(
                                                  dialog.actorName ?? '',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: isEven
                                                        ? Colors.black
                                                        : Colors.white,
                                                  ),
                                                  textAlign: isEven
                                                      ? TextAlign.start
                                                      : TextAlign.end,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Image.asset(
                                                  ganderImage,
                                                  width: 30,
                                                  height: 30,
                                                ),
                                              ],
                                            ),
                                      Text(
                                        dialog.conversationEn ?? '',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: isEven
                                              ? Colors.black
                                              : Colors.white,
                                        ),
                                        textAlign: isEven
                                            ? TextAlign.start
                                            : TextAlign.end,
                                      ),
                                      Text(
                                        dialog.conversationBn ?? '',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: isEven
                                              ? Colors.black
                                              : Colors.white,
                                        ),
                                        textAlign: isEven
                                            ? TextAlign.start
                                            : TextAlign.end,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  }
                }
              },
            ),
          );
        });
  }

  /*Bottom Scrollable container  for Sentences*/
  /*Widget SentenceContainer(int _vocabularyId) {
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
                    child: SpinKitThreeBounce(
                      color: AppColors.primaryColor,
                    ),
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
                      // controller: controller,
                      shrinkWrap: true,
                      itemCount: sentenceList.length,
                      itemBuilder: (context, index) {
                        final sentence = sentenceList[index];
                        return Container(
                          decoration: BoxDecoration(
                            color: AppColors.backgroundColorDark,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          padding: EdgeInsets.all(8.0),
                          margin: EdgeInsets.all(5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                sentence.vocaSentence ?? '--',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                sentence.vocaSentenceBn ?? '--',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              Positioned(
                                left: 0,
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primaryColor
                                          .withOpacity(0.3),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                    ),
                                    onPressed: () {
                                      Source url =
                                          UrlSource(sentence.vocaAudioFile!);
                                      audioPlayer.play(url);
                                    },
                                    child: const Text(
                                      "Play Audio",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                }
              },
            ),
          );
        });
  }*/
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
                  child: SpinKitThreeBounce(
                    color: AppColors.primaryColor,
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else {
                final sentenceList = vocabularySentenceListProvider
                    .vocabularySentenceListResponse?.sentenceList;
                print("hello ${sentenceList?.length.toString()}");

                if (sentenceList == null || sentenceList.isEmpty) {
                  return Center(
                    child: Text('No data available'),
                  );
                } else {
                  return SingleChildScrollView(
                    controller: controller,
                    child: Column(
                      children: [
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: sentenceList.length,
                          itemBuilder: (context, index) {
                            final sentence = sentenceList[index];
                            return Stack(
                              // Wrap with Stack
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.backgroundColorDark,
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      padding: EdgeInsets.all(8.0),
                                      margin: EdgeInsets.all(5.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            sentence.vocaSentence ?? '--',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            sentence.vocaSentenceBn ?? '--',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Align(
                                      // Replace Positioned with Align
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                AppColors.primaryColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                            ),
                                          ),
                                          onPressed: () {
                                            Source url = UrlSource(
                                                sentence.vocaAudioFile!);
                                            audioPlayer.play(url);
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Text(
                                                "Listen",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Icon(
                                                Icons.volume_up_rounded,
                                                color: Colors.white,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  );
                }
              }
            },
          ),
        );
      },
    );
  }
}
