import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';
import 'package:risho_speech/models/suggestAnswerDataModel.dart';
import 'package:risho_speech/models/validateSpokenSentenceDataModel.dart';
import 'package:risho_speech/providers/nextQuestionProvider.dart';
import 'package:risho_speech/providers/suggestAnswerProvider.dart';
import 'package:risho_speech/ui/colors.dart';

import '../../providers/auth_provider.dart';
import '../../providers/doConversationProvider.dart';
import '../../providers/validateSpokenSentenceProvider.dart';
import '../packages_screen.dart';

class ChatScreenTablet extends StatefulWidget {
  final int id;
  final String sessionId;
  final String aiDialogue;
  final String aiDialogueAudio;
  final String aiTranslation;
  final String actorName;
  final String isFemale;

  const ChatScreenTablet(
      {super.key,
      required this.id,
      required this.sessionId,
      required this.aiDialogue,
      required this.aiDialogueAudio,
      required this.aiTranslation,
      required this.actorName,
      required this.isFemale});

  @override
  State<ChatScreenTablet> createState() => _ChatScreenTabletState();
}

class _ChatScreenTabletState extends State<ChatScreenTablet> {
  bool _isFeedbackLoading = false;
  late bool isSessionIdFetched = false;
  late bool _isSuggestAnsActive = false;

  String? _audioPath;
  bool _isRecording = false;
  bool _isAiTranslation = false;
  bool _isUserTranslation = false;
  late Record audioRecord;
  late AudioPlayer audioPlayer;

  List<Widget> _conversationComponents = [];

  List<Widget> _aiResponseComponents = [];
  List<Widget> _userTextComponents = [];
  TextEditingController _askQuescontroller = TextEditingController();
  ScrollController _scrollController = ScrollController();
  bool _isTextQuestion = false;
  bool _isMyMessage = false;
  File? audioFile;
  late String? latestQuestion;

  late String? sessionId;

  late DoConversationProvider doConversationProvider =
      Provider.of<DoConversationProvider>(context, listen: false);
  late ValidateSentenceProvider validateSentenceProvider =
      Provider.of<ValidateSentenceProvider>(context, listen: false);
  late SuggestAnswerProvider suggestAnswerProvider =
      Provider.of<SuggestAnswerProvider>(context, listen: false);
  late NextQuestionProvider nextQuestionProvider =
      Provider.of<NextQuestionProvider>(context, listen: false);
  late AuthProvider authController =
      Provider.of<AuthProvider>(context, listen: false);
  late String? suggestedAnswer = '';
  late String inputText = '';
  late String userName = authController.user!.username ?? "username";
  late int userId = authController.user!.id ?? 123;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    audioRecord = Record();
    _askQuescontroller.addListener(_textChangeListener);
    _requestMicrophonePermission();
    // fetchSessionId();
    setState(() {
      sessionId = widget.sessionId;
    });
    _conversationComponents.add(firstConversation());
  }

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
          _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut);
          _conversationComponents.add(
            AIResponseBox(audioFile!, sessionId, userName),
          );
        });
        _isSuggestAnsActive = false;
        suggestedAnswer = null;
        // await _convertToWav(_audioPath!);
      }
    } catch (e) {
      print("Error stop recording: $e");
    }
  }

  Future<void> playRecording() async {
    try {
      Source urlSource = UrlSource(_audioPath!);
      await audioPlayer.play(urlSource);
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  Future<void> _requestMicrophonePermission() async {
    final status = await Permission.microphone.request();
    if (status == PermissionStatus.granted) {
      print('Microphone permission granted');
    } else if (status == PermissionStatus.permanentlyDenied) {
      await openAppSettings();
    } else {
      print('Microphone permission denied');
    }
  }

  @override
  void dispose() {
    _askQuescontroller.removeListener(_textChangeListener);
    _askQuescontroller.dispose();
    audioRecord.dispose();
    audioPlayer.dispose();
    sessionId = null;
    latestQuestion = null;
    super.dispose();
  }

  // late String username = '';

  void _textChangeListener() {
    setState(() {
      _isTextQuestion = _askQuescontroller.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    final username =
        Provider.of<AuthProvider>(context).user?.name ?? 'UserName';
    userId = Provider.of<AuthProvider>(context).user?.id ?? 123;
    return Scaffold(
      appBar: AppBar(
        title: Text("Risho"),
      ),
      body: Column(
        children: [
          /*top*/
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: BouncingScrollPhysics(),
              child: Column(
                children: _conversationComponents,
              ),
            ),
          ),
          /*Bottom control*/
          Visibility(
            visible: _isSuggestAnsActive,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.secondaryColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(16.0),
              ),
              margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      suggestedAnswer ?? "",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  IconButton(
                    style: ElevatedButton.styleFrom(),
                    onPressed: () {
                      setState(() {
                        _isSuggestAnsActive = false;
                        suggestedAnswer = null;
                      });
                    },
                    icon: Icon(
                      Icons.close,
                      color: AppColors.secondaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.backgroundColorDark,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24.0),
                topRight: Radius.circular(24.0),
              ),
            ),
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: [
                /*Question Asking*/
                _isRecording
                    ? Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(10.0),
                        child: Text("Recording in progress ..."),
                      )
                    : TextField(
                        controller: _askQuescontroller,
                        maxLines: 3,
                        minLines: 1,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenHeight * 0.020,
                        ),
                        cursorColor: AppColors.primaryColor,
                        decoration: const InputDecoration(
                          hintText: 'Type or Speak..',
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                        ),
                        onChanged: (value) {
                          inputText = value;
                          setState(() {
                            _isTextQuestion = value.isNotEmpty;
                            _isMyMessage = true;
                          });
                        },
                      ),
                SizedBox(
                  height: 5,
                ),
                /*SEND / VOICE*/
                _isTextQuestion == true
                    ? IconButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          elevation: 4,
                        ),
                        onPressed: () {
                          // Add your logic to send the message
                          _scrollController.animateTo(
                              _scrollController.position.maxScrollExtent,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOut);
                          setState(() {
                            _conversationComponents
                                .add(UserTextAIResponse(inputText, username));
                            /*_conversationComponents
                                .add(AIResponseBox(audioFile!, sessionId));*/

                            _askQuescontroller.clear();
                            _isSuggestAnsActive = false;
                          });
                        },
                        icon: Container(
                          padding: EdgeInsets.all(screenHeight * 0.010),
                          child: Icon(
                            Icons.send_rounded,
                            color: AppColors.primaryColor,
                            size: screenHeight * 0.03,
                          ),
                        ))
                    : AvatarGlow(
                        animate: _isRecording,
                        curve: Curves.fastOutSlowIn,
                        glowColor: AppColors.primaryColor,
                        duration: const Duration(milliseconds: 1000),
                        repeat: true,
                        glowRadiusFactor: 1,
                        child: IconButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isRecording == false
                                ? Colors.white
                                : AppColors.primaryColor,
                            elevation: 4,
                          ),
                          onPressed: () async {
                            /*_onMicrophoneButtonPressed;*/
                            if (!_isRecording) {
                              await startRecording();
                            } else {
                              await stopRecording();
                            }
                            setState(
                                () {}); // Update UI based on recording state
                          },
                          icon: Container(
                            padding: EdgeInsets.all(screenHeight * 0.020),
                            child: Icon(
                              _isRecording == false
                                  ? Icons.keyboard_voice_rounded
                                  : Icons.stop_rounded,
                              /*Icons.keyboard_voice_rounded,*/
                              color: _isRecording == false
                                  ? AppColors.primaryColor
                                  : Colors.white,
                              size: screenHeight * 0.04,
                            ),
                          ),
                        ),
                      ),
                // NEW QUESTION
                Container(
                  margin: EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 1,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          elevation: 3,
                        ),
                        onPressed: () {
                          // Add your logic to send the message
                          _scrollController.animateTo(
                              _scrollController.position.maxScrollExtent,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOut);
                          setState(() {
                            _conversationComponents.add(UserTextAIResponse(
                                "Ask me another Ques", username));
                          });
                        },
                        child: Text(
                          "New Ques.",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget firstConversation() {
    Source urlSource = UrlSource(widget.aiDialogueAudio);
    audioPlayer.play(urlSource);
    setState(() {
      latestQuestion = widget.aiDialogue;
    });
    return Container(
      padding: EdgeInsets.all(5.0),
      child: Column(
        children: [
          /*Ai Row*/
          Row(
            children: [
              Expanded(
                flex: 7,
                child: Container(
                  padding: EdgeInsets.all(5.0),
                  // color: Colors.white,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          // padding: EdgeInsets.all(5.0),
                          margin: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 5.0),
                          child: Image.asset(
                            "assets/images/risho_guru_icon.png",
                            height: 30,
                            width: 30,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 7,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            color: AppColors.primaryColor.withOpacity(0.3),
                          ),
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            widget.aiDialogue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Source urlSource =
                                  UrlSource(widget.aiDialogueAudio);
                              audioPlayer.play(urlSource);
                            },
                            icon: Icon(
                              Icons.volume_down_rounded,
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text('Translation'),
                                  content: Text(widget.aiTranslation),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.translate_rounded,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 1,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _isFeedbackLoading
                    ? CircularProgressIndicator() // Show a loader while loading
                    : TextButton(
                        onPressed: () {
                          setState(() {
                            _isSuggestAnsActive = true;
                          });

                          fetchDataAndShowBottomSheet(widget.aiDialogue, "S")
                              .whenComplete(() {});
                        },
                        child: Text(
                          "Suggest Answer",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                SizedBox(
                  width: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget AIResponseBox(File? audio, String? sessionId, String username) {
    print(sessionId);

    return FutureBuilder<void>(
        future: doConversationProvider.fetchConversationResponse(
            userId, widget.id, sessionId, audio, '', '', '', username),
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
            String aiDialog =
                doConversationProvider.conversationResponse!.aiDialogue!;

            /*setState(() {
              latestQuestion = aiDialog;
            });*/
            // updateLatestQuestion(aiDialog);
            return buildAiResponse(context, snapshot);
          }
        });
  }

  Widget buildAiResponse(BuildContext context, AsyncSnapshot<void> snapshot) {
    int errorCode = doConversationProvider.conversationResponse!.errorCode!;
    if (errorCode == 200) {
      String aiDialogAudio =
          doConversationProvider.conversationResponse!.aiDialogueAudio!;
      String aiDialogText =
          doConversationProvider.conversationResponse!.aiDialogue ?? "";
      String userAudio =
          doConversationProvider.conversationResponse!.userAudio!;
      double accuracyScore =
          doConversationProvider.conversationResponse!.accuracyScore ?? 0.0;
      double fluencyScore =
          doConversationProvider.conversationResponse!.fluencyScore ?? 0.0;
      double completenessScore =
          doConversationProvider.conversationResponse!.completenessScore ?? 0.0;
      double prosodyScore =
          doConversationProvider.conversationResponse!.prosodyScore ?? 0.0;
      String userText =
          doConversationProvider.conversationResponse!.userText ?? "";
      String userTranslation =
          doConversationProvider.conversationResponse!.userTextBn ??
              "Not Found";
      String aiTranslation =
          doConversationProvider.conversationResponse!.aiDialogueBn ??
              "Not Found";
      Source urlSource = UrlSource(aiDialogAudio);
      audioPlayer.play(urlSource);
      return Container(
        padding: EdgeInsets.all(5.0),
        child: Column(
          children: [
            /*UserRow*/
            userText != ""
                ? Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: IconButton(
                                      onPressed: () {
                                        ShowInfoDialog(
                                            userText,
                                            accuracyScore,
                                            fluencyScore,
                                            completenessScore,
                                            prosodyScore);
                                      },
                                      icon: const Icon(
                                        Icons.info_outline,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: IconButton(
                                      onPressed: () {
                                        showDialog<String>(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                            title: const Text('Translation'),
                                            content: Text(userTranslation),
                                          ),
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.translate_rounded,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: IconButton(
                                      onPressed: () {
                                        Source urlSource = UrlSource(userAudio);
                                        audioPlayer.play(urlSource);
                                        // print(urlSource);
                                      },
                                      icon: const Icon(
                                        Icons.volume_down_rounded,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 7,
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Expanded(
                                        flex: 7,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            color: AppColors.secondaryColor
                                                .withOpacity(0.3),
                                          ),
                                          padding: EdgeInsets.all(10.0),
                                          child: Text(
                                            _isUserTranslation == false
                                                ? userText
                                                : userTranslation,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          margin: EdgeInsets.fromLTRB(
                                              5.0, 0.0, 5.0, 5.0),
                                          child: Image.asset(
                                            "assets/images/profile_chat.png",
                                            height: 30,
                                            width: 30,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      /*FEEDBACK*/
                      Container(
                        padding:
                            const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 2,
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isFeedbackLoading = true;
                                });
                                fetchDataAndShowBottomSheet(userText, "F")
                                    .whenComplete(() {
                                  setState(() {
                                    _isFeedbackLoading = false;
                                  });
                                });
                              },
                              child: _isFeedbackLoading
                                  ? CircularProgressIndicator() // Show a loader while loading
                                  : const Text(
                                      "Correction",
                                      style: TextStyle(color: Colors.white),
                                    ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                    ],
                  )
                : Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color: AppColors.secondaryColor.withOpacity(0.1),
                    ),
                    padding: EdgeInsets.all(10.0),
                    child: Text("Couldn\'t capture your voice"),
                  ),

            /*Ai Row*/
            aiDialogText != ""
                ? Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 7,
                            child: Container(
                              padding: EdgeInsets.all(5.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      margin: EdgeInsets.fromLTRB(
                                          5.0, 0.0, 5.0, 5.0),
                                      child: Image.asset(
                                        "assets/images/risho_guru_icon.png",
                                        height: 30,
                                        width: 30,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 7,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        color: AppColors.primaryColor
                                            .withOpacity(0.3),
                                      ),
                                      padding: EdgeInsets.all(10.0),
                                      child: Text(
                                        aiDialogText,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Source urlSource =
                                          UrlSource(aiDialogAudio);
                                      audioPlayer.play(urlSource);
                                    },
                                    icon: Icon(
                                      Icons.volume_down_rounded,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: IconButton(
                                      onPressed: () {
                                        showDialog<String>(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                            title: const Text('Translation'),
                                            content: Text(aiTranslation),
                                          ),
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.translate_rounded,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 1,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _isFeedbackLoading
                                ? CircularProgressIndicator() // Show a loader while loading
                                : ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        _isSuggestAnsActive = true;
                                      });

                                      fetchDataAndShowBottomSheet(
                                              widget.aiDialogue, "S")
                                          .whenComplete(() {});
                                    },
                                    child: Text(
                                      "Suggest Answer",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                            SizedBox(
                              width: 2,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                    ],
                  )
                : SizedBox(
                    width: 2,
                  ),
          ],
        ),
      );
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
                "Sorry: ${doConversationProvider.conversationResponse!.message}",
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
      return Container(
        padding: EdgeInsets.all(12.0),
        child: Text(doConversationProvider.conversationResponse!.message!),
      );
    }
  }

  Widget buildAiTextResponse(
    BuildContext context,
    AsyncSnapshot<void> snapshot,
    NextQuestionProvider nextQuesProvider,
  ) {
    final response = nextQuesProvider.nextQuestionResponse;
    int errorCode = nextQuesProvider.nextQuestionResponse!.errorCode!;
    if (errorCode == 200) {
      String aiDialogAudio = response!.aiDialogAudio!;
      String aiDialogText = response!.aiDialog ?? "";
      String userAudio = response!.userAudio!;
      double accuracyScore = response!.accuracyScore!;
      double fluencyScore = response!.fluencyScore!;
      double completenessScore = response!.completenessScore!;
      double prosodyScore = response!.prosodyScore!;
      String userText = response!.userText ?? "";
      String userTranslation = response!.userTextBn ?? "Not Found";
      String aiTranslation = response!.aiDialogBn ?? "Not Found";
      if (aiDialogAudio != null) {
        Source urlSource = UrlSource(aiDialogAudio);
        audioPlayer.play(urlSource);
      }
      // setState(() {
      //   latestQuestion = aiDialogText;
      // });

      return Container(
        padding: EdgeInsets.all(5.0),
        child: Column(
          children: [
            /*UserRow*/
            userText != ""
                ? Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: IconButton(
                                      onPressed: () {
                                        ShowInfoDialog(
                                            userText,
                                            accuracyScore,
                                            fluencyScore,
                                            completenessScore,
                                            prosodyScore);
                                      },
                                      icon: const Icon(
                                        Icons.info_outline,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: IconButton(
                                      onPressed: () {
                                        showDialog<String>(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                            title: const Text('Translation'),
                                            content: Text(userTranslation),
                                          ),
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.translate_rounded,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: IconButton(
                                      onPressed: () {
                                        Source urlSource = UrlSource(userAudio);
                                        audioPlayer.play(urlSource);
                                        // print(urlSource);
                                      },
                                      icon: const Icon(
                                        Icons.volume_down_rounded,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 7,
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Expanded(
                                        flex: 7,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            color: AppColors.secondaryColor
                                                .withOpacity(0.3),
                                          ),
                                          padding: const EdgeInsets.all(10.0),
                                          child: Text(
                                            _isUserTranslation == false
                                                ? userText
                                                : userTranslation,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          margin: EdgeInsets.fromLTRB(
                                              5.0, 0.0, 5.0, 5.0),
                                          child: Image.asset(
                                            "assets/images/profile_chat.png",
                                            height: 30,
                                            width: 30,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      /*FEEDBACK*/
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 2,
                            ),
                            _isFeedbackLoading
                                ? CircularProgressIndicator() // Show a loader while loading
                                : ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        _isFeedbackLoading = true;
                                      });
                                      fetchDataAndShowBottomSheet(userText, "F")
                                          .whenComplete(() {
                                        setState(() {
                                          _isFeedbackLoading = false;
                                        });
                                      });
                                    },
                                    child: const Text(
                                      "Correction",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                    ],
                  )
                : SizedBox(
                    width: 2,
                  ),
            /*Ai Row*/
            aiDialogText != ""
                ? Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 7,
                            child: Container(
                              padding: EdgeInsets.all(5.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      margin: EdgeInsets.fromLTRB(
                                          5.0, 0.0, 5.0, 5.0),
                                      child: Image.asset(
                                        "assets/images/risho_guru_icon.png",
                                        height: 30,
                                        width: 30,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 7,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        color: AppColors.primaryColor
                                            .withOpacity(0.3),
                                      ),
                                      padding: EdgeInsets.all(10.0),
                                      child: Text(
                                        aiDialogText,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Source urlSource =
                                          UrlSource(aiDialogAudio);
                                      audioPlayer.play(urlSource);
                                    },
                                    icon: Icon(
                                      Icons.volume_down_rounded,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: IconButton(
                                      onPressed: () {
                                        showDialog<String>(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                            title: const Text('Translation'),
                                            content: Text(aiTranslation),
                                          ),
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.translate_rounded,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 1,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      /*Suggest Answer*/
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _isFeedbackLoading
                                ? CircularProgressIndicator() // Show a loader while loading
                                : TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _isSuggestAnsActive = true;
                                      });

                                      fetchDataAndShowBottomSheet(
                                              widget.aiDialogue, "S")
                                          .whenComplete(() {});
                                    },
                                    child: Text(
                                      "Suggest Answer",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                            SizedBox(
                              width: 2,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                    ],
                  )
                : SizedBox(
                    width: 2,
                    child: Text(
                        doConversationProvider.conversationResponse!.message ??
                            "Some error in server"),
                  ),
          ],
        ),
      );
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
                "Sorry: ${doConversationProvider.conversationResponse!.message}",
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
      return Container(
        padding: EdgeInsets.all(12.0),
        child: Text(doConversationProvider.conversationResponse!.message!),
      );
    }
  }

  Future ShowInfoDialog(String userText, double accuracyScore,
      double fluencyScore, double completenessScore, double prosodyScore) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          width: double.infinity,
          margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                userText,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                                  value: accuracyScore /
                                      100, // value should be between 0 and 1
                                  backgroundColor: Colors.grey[300],
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColors.primaryColor),
                                ),
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Expanded(
                                flex: 2,
                                child: Text("${accuracyScore.toString()}%"),
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
                                  value: fluencyScore /
                                      100, // value should be between 0 and 1
                                  backgroundColor: Colors.grey[300],
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColors.primaryColor),
                                ),
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Expanded(
                                flex: 2,
                                child: Text("${fluencyScore.toString()}%"),
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
                                  value: completenessScore /
                                      100, // value should be between 0 and 1
                                  backgroundColor: Colors.grey[300],
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColors.primaryColor),
                                ),
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Expanded(
                                flex: 2,
                                child: Text("${completenessScore.toString()}%"),
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
                                  value: prosodyScore /
                                      100, // value should be between 0 and 1
                                  backgroundColor: Colors.grey[300],
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColors.primaryColor),
                                ),
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Expanded(
                                flex: 2,
                                child: Text("${prosodyScore.toString()}%"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  /*Feedback dialog content column*/
  Widget buildFeedbackContentColumn(String title, String content) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      margin: EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 2.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.bold, color: AppColors.primaryColor),
          ),
          SizedBox(width: 5),
          Text(
            content,
            style: TextStyle(fontFamily: "Mina"),
          ),
        ],
      ),
    );
  }

  /*Feedback Bottom*/
  Future<void> fetchDataAndShowBottomSheet(
      String userText, String button) async {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dialog dismissal
      builder: (BuildContext context) {
        return Center(
          child: SpinKitChasingDots(
            color: Colors.green,
          ), // Show loader
        );
      },
    );
    try {
      if (button == "F") {
        // Fetch data
        await validateSentenceProvider.fetchValidateSentenceResponse(userText);
        // Show bottom sheet with fetched data
        Navigator.pop(context);
        FeedbackBottomDialog(
          userText,
          validateSentenceProvider.validateSentenceResponse,
        );
      } else if (button == "S") {
        // Fetch data
        await suggestAnswerProvider.fetchSuggestAnswerResponse(userText);
        // Show bottom sheet with fetched data
        Navigator.pop(context);
        SuggestAnswer(
          userText,
          suggestAnswerProvider.suggestAnswerResponse,
        );
      }
    } catch (error) {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(error.toString()),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
      // Handle error
    }
  }

  // Modified FeedbackBottomDialog function to accept data
  Future<void> FeedbackBottomDialog(
    String userText,
    ValidateSentenceDataModel? responseData,
  ) async {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        if (responseData == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Feedback",
                    style: TextStyle(
                        // color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 24),
                  ),
                  buildFeedbackContentColumn(
                    'Correct Sentence:',
                    responseData.correctSentence,
                  ),
                  buildFeedbackContentColumn(
                    'Explanation:',
                    responseData.explanation,
                  ),
                  buildFeedbackContentColumn(
                    'Alternate Sentence:',
                    responseData.alternate,
                  ),
                  buildFeedbackContentColumn(
                    'Bangla Explanation:',
                    responseData.banglaExplanation,
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget UserTextAIResponse(String text, String username) {
    final nextQuesProvider =
        Provider.of<NextQuestionProvider>(context, listen: false);
    return FutureBuilder<void>(
        future: nextQuesProvider.fetchNextQuestionResponse(
            59350, widget.id, sessionId!, text, '', username),
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
            return buildAiTextResponse(context, snapshot, nextQuesProvider);
          }
        });
  }

  Future<void> SuggestAnswer(
    String text,
    SuggestAnswerDataModel? responseData,
  ) async {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dialog dismissal
      builder: (BuildContext context) {
        return Center(
          child: SpinKitChasingDots(
            color: Colors.green,
          ), // Show loader
        );
      },
    );
    try {
      // var response =
      //     await suggestAnswerProvider.fetchSuggestAnswerResponse(text);

      Navigator.pop(context);
      setState(() {
        suggestedAnswer = responseData!.replyText!;
      });
      /*showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Try to Say this"),
            content: Text(responseData!.replyText!),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );*/
      // print("$sessionId, $aiDialogue");
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(e.toString()),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
      // Handle error
    }
    /*return FutureBuilder<void>(
        future: suggestAnswerProvider.fetchSuggestAnswerResponse(text),
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
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Try to say it"),
                  content: Text(
                      suggestAnswerProvider.suggestAnswerResponse!.replyText!),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("OK"),
                    ),
                  ],
                );
              },
            );
          }
        });*/
  }
}
