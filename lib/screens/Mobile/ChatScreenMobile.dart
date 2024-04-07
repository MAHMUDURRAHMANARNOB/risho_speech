import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';
import 'package:risho_speech/models/validateSpokenSentenceDataModel.dart';
import 'package:risho_speech/providers/nextQuestionProvider.dart';
import 'package:risho_speech/providers/suggestAnswerProvider.dart';
import 'package:risho_speech/ui/colors.dart';

import '../../providers/doConversationProvider.dart';
import '../../providers/validateSpokenSentenceProvider.dart';

class ChatScreenMobile extends StatefulWidget {
  final String id;
  ChatScreenMobile({super.key, required this.id});

  @override
  State<ChatScreenMobile> createState() => _ChatScreenMobileState();
}

class _ChatScreenMobileState extends State<ChatScreenMobile> {
  bool _isFeedbackLoading = false;

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

  late String? sessionId;

  late DoConversationProvider doConversationProvider =
      Provider.of<DoConversationProvider>(context, listen: false);
  late ValidateSentenceProvider validateSentenceProvider =
      Provider.of<ValidateSentenceProvider>(context, listen: false);
  late SuggestAnswerProvider suggestAnswerProvider =
      Provider.of<SuggestAnswerProvider>(context, listen: false);
  late NextQuestionProvider nextQuestionProvider =
      Provider.of<NextQuestionProvider>(context, listen: false);

  late String inputText = '';

  // late String aiResponseText;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    audioRecord = Record();
    _askQuescontroller.addListener(_textChangeListener);
    _requestMicrophonePermission();
    fetchSessionId();
    setState(() {
      sessionId = doConversationProvider.conversationResponse!.sessionId;
    });
  }

  Future<void> fetchSessionId() async {
    try {
      setState(() {
        _conversationComponents.add(
          AIResponseBox(null, null),
        );
      });
    } catch (error) {
      print('Error fetching session ID: $error');
      // Handle error
    }
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
          _conversationComponents.add(
            AIResponseBox(audioFile!, sessionId),
          );
        });
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
    super.dispose();
  }

  void _textChangeListener() {
    setState(() {
      _isTextQuestion = _askQuescontroller.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Risho"),
        actions: [
          IconButton(
            icon: const Icon(Icons.mark_unread_chat_alt_outlined),
            tooltip: 'Show Snack bar',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('This is a snack-bar')));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          /*top*/
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              child: Column(
                children: _conversationComponents,
              ),
            ),
          ),
          /*Bottom control*/
          Container(
            margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.backgroundColorDark),
                  onPressed: () {
                    // Add your logic to send the message
                    setState(() {
                      _conversationComponents
                          .add(UserTextAIResponse("Ask me another Ques"));
                    });
                  },
                  child: Text(
                    "New Question",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.backgroundColorDark),
                  onPressed: () {
                    // Add your logic to send the message
                  },
                  child: Text(
                    "Suggest Answer",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: AppColors.backgroundColorDark,
            padding: const EdgeInsets.all(5.0),
            child: Row(
              children: [
                /*SPEAKER*/
                IconButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.backgroundColorDark),
                  onPressed: () {
                    /* _pickImage(context);*/
                  },
                  icon: const Icon(
                    Icons.volume_up_rounded,
                    color: AppColors.primaryColor,
                    size: 18,
                  ),
                ),
                /*Question Asking*/
                Expanded(
                  child: _isRecording
                      ? Text("Recording in progress")
                      : TextField(
                          controller: _askQuescontroller,
                          maxLines: 3,
                          minLines: 1,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          cursorColor: AppColors.primaryColor,
                          decoration: const InputDecoration(
                            hintText: 'Type your message...',
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.primaryColor,
                              ),
                            ),
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
                ),
                /*SEND / VOICE*/
                _isTextQuestion == true
                    ? IconButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.backgroundColorDark),
                        onPressed: () {
                          // Add your logic to send the message
                          setState(() {
                            _conversationComponents
                                .add(UserTextAIResponse(inputText));
                            /*_conversationComponents
                                .add(AIResponseBox(audioFile!, sessionId));*/

                            _askQuescontroller.clear();
                          });
                        },
                        icon: Icon(
                          Icons.send_rounded,
                          color: AppColors.primaryColor,
                          size: 18,
                        ))
                    : IconButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.backgroundColorDark),
                        onPressed: () async {
                          /*_onMicrophoneButtonPressed;*/
                          if (!_isRecording) {
                            await startRecording();
                          } else {
                            await stopRecording();
                          }
                          setState(() {}); // Update UI based on recording state
                        },
                        icon: Icon(
                          _isRecording == false
                              ? Icons.keyboard_voice_rounded
                              : Icons.stop_rounded,
                          /*Icons.keyboard_voice_rounded,*/
                          color: AppColors.primaryColor,
                          size: 18,
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget AIResponseBox(File? audio, String? sessionId) {
    if (sessionId == null) {
      return FutureBuilder<void>(
          future: doConversationProvider.fetchConversationResponse(
              59350, 2, sessionId, audio, '', '', 'N', 'Risho'),
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
              String aiDialogAudio =
                  doConversationProvider.conversationResponse!.aiDialogueAudio!;
              String aiDialogText =
                  doConversationProvider.conversationResponse!.aiDialogue!;
              String userAudio =
                  doConversationProvider.conversationResponse!.userAudio!;
              String accuracyScore = doConversationProvider
                  .conversationResponse!.accuracyScore
                  .toString();
              String fluencyScore = doConversationProvider
                  .conversationResponse!.fluencyScore
                  .toString();
              String completenessScore = doConversationProvider
                  .conversationResponse!.completenessScore
                  .toString();
              String prosodyScore = doConversationProvider
                  .conversationResponse!.prosodyScore
                  .toString();
              String userText =
                  doConversationProvider.conversationResponse!.userText!;
              String sessionid =
                  doConversationProvider.conversationResponse!.sessionId!;
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
                    /*Ai Row*/
                    Row(
                      children: [
                        Expanded(
                          flex: 7,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              color: AppColors.primaryColor.withOpacity(0.3),
                            ),
                            padding: EdgeInsets.all(5.0),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Image.asset(
                                    "assets/images/risho_guru_icon.png",
                                    height: 30,
                                    width: 30,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: SizedBox(
                                    width: 1.0,
                                  ),
                                ),
                                Expanded(
                                  flex: 8,
                                  child: _isAiTranslation == false
                                      ? Text(
                                          aiDialogText,
                                        )
                                      : Text(aiTranslation),
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
                                            UrlSource(aiDialogAudio);
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
                  ],
                ),
              );
            }
          });
    }
    return FutureBuilder<void>(
        future: doConversationProvider.fetchConversationResponse(
            59350, 2, sessionId, audio, '', '', 'N', 'Risho'),
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
            return buildAiResponse(context, snapshot);
          }
        });
  }

  Widget buildAiResponse(BuildContext context, AsyncSnapshot<void> snapshot) {
    String aiDialogAudio =
        doConversationProvider.conversationResponse!.aiDialogueAudio!;
    String aiDialogText =
        doConversationProvider.conversationResponse!.aiDialogue!;
    String userAudio = doConversationProvider.conversationResponse!.userAudio!;
    String accuracyScore =
        doConversationProvider.conversationResponse!.accuracyScore.toString();
    String fluencyScore =
        doConversationProvider.conversationResponse!.fluencyScore.toString();
    String completenessScore = doConversationProvider
        .conversationResponse!.completenessScore
        .toString();
    String prosodyScore =
        doConversationProvider.conversationResponse!.prosodyScore.toString();
    String userText = doConversationProvider.conversationResponse!.userText!;
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
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.0),
                                  color:
                                      AppColors.secondaryColor.withOpacity(0.3),
                                ),
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      flex: 8,
                                      child: Text(
                                        _isUserTranslation == false
                                            ? userText
                                            : userTranslation,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: SizedBox(
                                        width: 1.0,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Image.asset(
                                        "assets/images/profile_chat.png",
                                        height: 30,
                                        width: 30,
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
                      padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
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
                              fetchDataAndShowBottomSheet(userText)
                                  .whenComplete(() {
                                setState(() {
                                  _isFeedbackLoading = false;
                                });
                              });
                            },
                            child: _isFeedbackLoading
                                ? CircularProgressIndicator() // Show a loader while loading
                                : Text(
                                    "Feedback",
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
          Row(
            children: [
              Expanded(
                flex: 7,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: AppColors.primaryColor.withOpacity(0.3),
                  ),
                  padding: EdgeInsets.all(5.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Image.asset(
                          "assets/images/risho_guru_icon.png",
                          height: 30,
                          width: 30,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          width: 1.0,
                        ),
                      ),
                      Expanded(
                        flex: 8,
                        child: Text(
                          aiDialogText,
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
                              builder: (BuildContext context) => AlertDialog(
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
        ],
      ),
    );
  }

  Widget buildAiTextResponse(
      BuildContext context, AsyncSnapshot<void> snapshot) {
    String aiDialogAudio =
        nextQuestionProvider.nextQuestionResponse!.aiDialogAudio!;
    String aiDialogText = nextQuestionProvider.nextQuestionResponse!.aiDialog!;
    String userAudio = nextQuestionProvider.nextQuestionResponse!.userAudio!;
    String accuracyScore =
        nextQuestionProvider.nextQuestionResponse!.accuracyScore.toString();
    String fluencyScore =
        nextQuestionProvider.nextQuestionResponse!.fluencyScore.toString();
    String completenessScore =
        nextQuestionProvider.nextQuestionResponse!.completenessScore.toString();
    String prosodyScore =
        nextQuestionProvider.nextQuestionResponse!.prosodyScore.toString();
    String userText = nextQuestionProvider.nextQuestionResponse!.userText!;
    String userTranslation =
        nextQuestionProvider.nextQuestionResponse!.userTextBn ?? "Not Found";
    String aiTranslation =
        nextQuestionProvider.nextQuestionResponse!.aiDialogBn ?? "Not Found";

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
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.0),
                                  color:
                                      AppColors.secondaryColor.withOpacity(0.3),
                                ),
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      flex: 8,
                                      child: Text(
                                        _isUserTranslation == false
                                            ? userText
                                            : userTranslation,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: SizedBox(
                                        width: 1.0,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Image.asset(
                                        "assets/images/profile_chat.png",
                                        height: 30,
                                        width: 30,
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
                      padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
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
                              fetchDataAndShowBottomSheet(userText)
                                  .whenComplete(() {
                                setState(() {
                                  _isFeedbackLoading = false;
                                });
                              });
                            },
                            child: _isFeedbackLoading
                                ? CircularProgressIndicator() // Show a loader while loading
                                : Text(
                                    "Feedback",
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
          Row(
            children: [
              Expanded(
                flex: 7,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: AppColors.primaryColor.withOpacity(0.3),
                  ),
                  padding: EdgeInsets.all(5.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Image.asset(
                          "assets/images/risho_guru_icon.png",
                          height: 30,
                          width: 30,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          width: 1.0,
                        ),
                      ),
                      Expanded(
                        flex: 8,
                        child: Text(
                          aiDialogText,
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
                              builder: (BuildContext context) => AlertDialog(
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
        ],
      ),
    );
  }

  Future ShowInfoDialog(String accuracyScore, String fluencyScore,
      String completenessScore, String prosodyScore) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Accuracy Score:"),
                  Text(accuracyScore),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Fluency Score:"),
                  Text(fluencyScore),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Completeness Score:"),
                  Text(completenessScore),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Prosody Score:"),
                  Text(prosodyScore),
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
            style: TextStyle(fontWeight: FontWeight.bold),
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
  Future<void> fetchDataAndShowBottomSheet(String userText) async {
    try {
      // Fetch data
      await validateSentenceProvider.fetchValidateSentenceResponse(userText);
      // Show bottom sheet with fetched data
      FeedbackBottomDialog(
        userText,
        validateSentenceProvider.validateSentenceResponse,
      );
    } catch (error) {
      print('Error fetching data: $error');
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
          return Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
          );
        }
      },
    );
  }

  Widget UserTextAIResponse(String text) {
    return FutureBuilder<void>(
        future: nextQuestionProvider.fetchNextQuestionResponse(
            59350, 2, sessionId!, text, '', 'N'),
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
            return buildAiTextResponse(context, snapshot);
          }
        });
  }
}
