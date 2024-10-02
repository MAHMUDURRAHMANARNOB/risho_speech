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
import 'package:shimmer/shimmer.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../../providers/auth_provider.dart';
import '../../providers/doConversationProvider.dart';
import '../../providers/validateSpokenSentenceProvider.dart';
import '../packages_screen.dart';

class ChatScreenMobile extends StatefulWidget {
  final int id;
  final String sessionId;
  final String aiDialogue;
  final String aiDialogueAudio;
  final String aiTranslation;
  final String actorName;
  final String isFemale;

  ChatScreenMobile(
      {super.key,
      required this.id,
      required this.sessionId,
      required this.aiDialogue,
      required this.aiDialogueAudio,
      required this.aiTranslation,
      required this.actorName,
      required this.isFemale});

  @override
  State<ChatScreenMobile> createState() => _ChatScreenMobileState();
}

class _ChatScreenMobileState extends State<ChatScreenMobile> {
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

  // late String aiResponseText;

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
        audioPlayer.stop();
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
        if (path != null) {
          path = path.replaceFirst('file://', ''); // Clean the path
          File file = File(path);
          if (await file.exists()) {
            audioFile = file;
            print("Recorded file path: $path");
          } else {
            print("File not found at path: $path");
          }
        }

        if (path != null && File(path).existsSync()) {
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
        }

        // await _convertToWav(_audioPath!);
        else {
          setState(() {
            _isRecording = false;
          });
          print("File not found at path: $path");
        }
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
    return SafeArea(
      child: Scaffold(
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
                // color: AppColors.primaryColor.withOpacity(0.2),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.0),
                  topRight: Radius.circular(24.0),
                ),
                border: Border.all(color: AppColors.primaryColor, width: 0.1),
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
                            hintText: 'Speak or Type..',
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
                  Stack(
                    children: [
                      // Send or Voice button
                      Align(
                        alignment: Alignment.center,
                        child: _isTextQuestion == true
                            ? IconButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  elevation: 4,
                                ),
                                onPressed: () {
                                  // Add your logic to send the message
                                  _scrollController.animateTo(
                                      _scrollController
                                          .position.maxScrollExtent,
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.easeOut);
                                  setState(() {
                                    _conversationComponents.add(
                                        UserTextAIResponse(
                                            inputText, username));
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
                                    padding:
                                        EdgeInsets.all(screenHeight * 0.020),
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
                      ),

                      // New Question
                      Positioned(
                        // alignment: Alignment.centerRight,
                        right: 2,
                        bottom: 10,
                        child: ElevatedButton(
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
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
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
                    : GestureDetector(
                        onTap: () {
                          setState(() {
                            _isSuggestAnsActive = true;
                          });

                          fetchDataAndShowBottomSheet(widget.aiDialogue, "S")
                              .whenComplete(() {});
                        },
                        child: Text(
                          "Suggest Answer",
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
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
        future: doConversationProvider.fetchConversationResponse(userId,
            widget.id, sessionId, audio, '', '', widget.isFemale, username),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              padding: EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 5.0),
                    child: Image.asset(
                      "assets/images/risho_guru_icon.png",
                      height: 30,
                      width: 30,
                    ),
                  ),
                  SizedBox(
                    child: Shimmer.fromColors(
                      baseColor: AppColors.primaryColor,
                      highlightColor: Colors.white,
                      child: const Text(
                        'Analyzing...',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
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
                      "Sorry: There might be some issues with your Internet connection.Please try again after sometime.",
                      /*Server error*/
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

            int? errorCode =
                doConversationProvider.conversationResponse!.errorCode;
            print(errorCode);

            if (errorCode == 200) {
              return buildAiResponse(context, snapshot);
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
                margin: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: AppColors.secondaryColor.withOpacity(0.1),
                ),
                padding: EdgeInsets.all(10.0),
                child: Text(doConversationProvider
                        .conversationResponse!.message ??
                    "404: There might be some issues with your Internet connection.Please try again after sometime."),
              );
            }
          }
        });
  }

  Widget buildAiResponse(BuildContext context, AsyncSnapshot<void> snapshot) {
    String aiDialogAudio =
        doConversationProvider.conversationResponse!.aiDialogueAudio!;
    String aiDialogText =
        doConversationProvider.conversationResponse!.aiDialogue ?? "";
    String userAudio = doConversationProvider.conversationResponse!.userAudio!;
    double pronScore =
        doConversationProvider.conversationResponse!.pronScore ?? 0.0;
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
        doConversationProvider.conversationResponse!.userTextBn ?? "Not Found";
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
                                          pronScore,
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
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 2,
                          ),
                          _isFeedbackLoading
                              ? CircularProgressIndicator() // Show a loader while loading
                              : GestureDetector(
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
                                  child: const Text(
                                    "Check Accuracy",
                                    style: TextStyle(
                                      color: AppColors.secondaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
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
                                    margin:
                                        EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 5.0),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Source urlSource = UrlSource(aiDialogAudio);
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
                      padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _isFeedbackLoading
                              ? CircularProgressIndicator() // Show a loader while loading
                              : GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isSuggestAnsActive = true;
                                    });

                                    fetchDataAndShowBottomSheet(
                                            aiDialogText, "S")
                                        .whenComplete(() {});
                                  },
                                  child: Text(
                                    "Suggest Answer",
                                    style: TextStyle(
                                      color: AppColors.primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
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
  }

  Widget buildAiTextResponse(
    BuildContext context,
    AsyncSnapshot<void> snapshot,
    NextQuestionProvider nextQuesProvider,
  ) {
    final response = nextQuesProvider.nextQuestionResponse;
    int errorCode = response!.errorCode!;
    if (errorCode == 200) {
      String aiDialogAudio = response!.aiDialogAudio!;
      String aiDialogText = response!.aiDialog ?? "";
      String userAudio = response!.userAudio!;
      double pronScore = response!.pronScore!;
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
                                            pronScore,
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
                      Container(
                        padding:
                            const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(
                              width: 2,
                            ),
                            _isFeedbackLoading
                                ? const CircularProgressIndicator() // Show a loader while loading
                                : GestureDetector(
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
                                    child: const Text(
                                      "Check Accuracy",
                                      style: TextStyle(
                                        color: AppColors.secondaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
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
                                : GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _isSuggestAnsActive = true;
                                      });

                                      fetchDataAndShowBottomSheet(
                                              aiDialogText, "S")
                                          .whenComplete(() {});
                                    },
                                    child: Text(
                                      "Suggest Answer",
                                      style: TextStyle(
                                        color: AppColors.primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
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

  Future ShowInfoDialog(String userText, double pronScore, double accuracyScore,
      double fluencyScore, double completenessScore, double prosodyScore) {
    Color getColorForScore(double pronScore) {
      if (pronScore <= 33.3) {
        return Colors.red;
      } else if (pronScore <= 66.6) {
        return Colors.orangeAccent;
      } else {
        return Colors.green;
      }
    }

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
            initialChildSize: 0.5,
            // initial height 50% of the screen
            minChildSize: 0.5,
            // minimum height 50% of the screen
            maxChildSize: 0.9,
            // maximum height 100% of the screen
            expand: false,
            builder: (BuildContext context, ScrollController scrollController) {
              return SingleChildScrollView(
                controller: scrollController,
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.fromLTRB(10.0, 12.0, 10.0, 0.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /*Text(
                        userText,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),*/
                      /*CustomPaint(
                        // size: width: 200, height: 100
                        painter: CustomPainter,
                      ),*/
                      SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.secondaryCardColorGreenish
                              .withOpacity(0.5),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: SfRadialGauge(
                          animationDuration: 500,
                          title: GaugeTitle(
                            text: 'Pronunciation Score',
                            textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          axes: <RadialAxis>[
                            RadialAxis(
                              /*startAngle: 180,
                                endAngle: 0,*/
                              interval: 10,
                              // canScaleToFit: true,
                              radiusFactor: 0.85,
                              minimum: 0,
                              maximum: 100,
                              showLabels: false,
                              // centerX: 0.8,
                              // centerY: 0.6,

                              // showTicks: false,
                              ranges: <GaugeRange>[
                                GaugeRange(
                                  startValue: 0,
                                  endValue: 100,
                                  color: AppColors.backgroundColorDark,
                                  // label: "Poor",
                                  labelStyle: GaugeTextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  startWidth: 30.0,
                                  endWidth: 30.0,
                                ),
                                /*GaugeRange(
                                    startValue: 0,
                                    endValue: 33.3,
                                    color: Colors.redAccent,
                                    label: "Poor",
                                    labelStyle: GaugeTextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    startWidth: 50.0,
                                    endWidth: 50.0,
                                  ),
                                  GaugeRange(
                                    startValue: 33.3,
                                    endValue: 66.6,
                                    color: Colors.orangeAccent,
                                    label: "Good",
                                    labelStyle: GaugeTextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    startWidth: 50.0,
                                    endWidth: 50.0,
                                  ),
                                  GaugeRange(
                                    startValue: 66.6,
                                    endValue: 100,
                                    color: Colors.green,
                                    label: "Perfect",
                                    labelStyle: GaugeTextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    startWidth: 50.0,
                                    endWidth: 50.0,
                                  ),*/
                              ],
                              pointers: <GaugePointer>[
                                RangePointer(
                                    value: pronScore,
                                    dashArray: <double>[8, 2],
                                    width: 30,
                                    // pointerOffset: 20,
                                    // cornerStyle: CornerStyle.bothCurve,
                                    color: getColorForScore(pronScore),
                                    sizeUnit: GaugeSizeUnit.logicalPixel),
                              ],

                              /*pointers: <GaugePointer>[
                                  MarkerPointer(
                                    value: pronScore,
                                    // needleLength: 0.7,
                                    // needleEndWidth: 4,
                                    enableAnimation: true,
                                    markerType: MarkerType.invertedTriangle,
                                    // needleColor: AppColors.primaryColor,
                                    animationType: AnimationType.slowMiddle,
                                    animationDuration: 500,
                                  ),
                                ],*/
                              annotations: <GaugeAnnotation>[
                                GaugeAnnotation(
                                  widget: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 5.0),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryColor2,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Text(
                                      "${pronScore.toString()}%",
                                      style: const TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  positionFactor: 0,
                                  angle: 90,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      info_bar(
                        title: 'Accuracy Score',
                        number: accuracyScore,
                        imagePath: "assets/images/accuracy.png",
                      ),
                      info_bar(
                        title: 'Fluency Score',
                        number: fluencyScore,
                        imagePath: "assets/images/fluency.png",
                      ),
                      info_bar(
                        title: 'Completeness Score:',
                        number: completenessScore,
                        imagePath: "assets/images/solution.png",
                      ),
                      info_bar(
                        title: 'Prosody Score:',
                        number: prosodyScore,
                        imagePath: "assets/images/prosody.png",
                      ),
                    ],
                  ),
                ),
              );
            });
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
      isScrollControlled: true,
      builder: (context) {
        if (responseData == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return DraggableScrollableSheet(
            initialChildSize: 0.5,
            // Initial height 50% of the screen
            minChildSize: 0.5,
            // Minimum height 50% of the screen
            maxChildSize: 0.9,
            // Maximum height 100% of the screen
            expand: false,
            builder: (BuildContext context, ScrollController scrollController) {
              return SingleChildScrollView(
                controller: scrollController,
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
            },
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
            59350, widget.id, sessionId!, text, widget.isFemale, username),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              padding: EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 5.0),
                    child: Image.asset(
                      "assets/images/risho_guru_icon.png",
                      height: 30,
                      width: 30,
                    ),
                  ),
                  SizedBox(
                    child: Shimmer.fromColors(
                      baseColor: AppColors.primaryColor,
                      highlightColor: Colors.white,
                      child: const Text(
                        'Analyzing...',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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
            int? errorCode = nextQuesProvider.nextQuestionResponse!.errorCode;
            /*doConversationProvider.conversationResponse!.errorCode;*/
            print(errorCode);
            if (errorCode == 200) {
              return buildAiTextResponse(context, snapshot, nextQuesProvider);
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
                        "Sorry: ${nextQuesProvider.nextQuestionResponse!.message}",
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
                margin: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: AppColors.secondaryColor.withOpacity(0.1),
                ),
                padding: EdgeInsets.all(10.0),
                child: Text(nextQuesProvider.nextQuestionResponse!.message ??
                    "404: Server Issue"),
              );
            }
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
      Navigator.pop(context);
      setState(() {
        suggestedAnswer = responseData!.replyText!;
      });
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
  }
}

class info_bar extends StatelessWidget {
  const info_bar({
    super.key,
    required this.title,
    required this.number,
    required this.imagePath,
  });

  final String title;
  final double number;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          /*"assets/images/accuracy.png"*/
          imagePath,
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
                Text(/*"Accuracy Score:"*/ title),
                Row(
                  children: [
                    Expanded(
                      flex: 8,
                      child: LinearProgressIndicator(
                        value: /*accuracyScore*/
                            number / 100, // value should be between 0 and 1
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
                      child: Text("${number.toString()}%"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
