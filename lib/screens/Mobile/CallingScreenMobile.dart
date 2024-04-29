import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';
import 'package:risho_speech/models/callAndConversationDataModel.dart';
import 'package:risho_speech/providers/callAndConversationProvider.dart';
import 'package:risho_speech/ui/colors.dart';

import '../../models/validateSpokenSentenceDataModel.dart';
import '../../providers/auth_provider.dart';
import '../../providers/validateSpokenSentenceProvider.dart';

class CallingScreenMobile extends StatefulWidget {
  final int agentId;
  final String agentName;
  final String sessionId;
  final String agentAudio;
  final String firstText;
  const CallingScreenMobile(
      {super.key,
      required this.agentId,
      required this.sessionId,
      required this.agentName,
      required this.agentAudio,
      required this.firstText});

  @override
  State<CallingScreenMobile> createState() => _CallingScreenMobileState();
}

class _CallingScreenMobileState extends State<CallingScreenMobile> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openEndDrawer() {
    _scaffoldKey.currentState!.openEndDrawer();
  }

  bool _isChatExpanded = false;

  bool _isRecording = false;
  late Record audioRecord;
  late AudioPlayer audioPlayer;
  File? audioFile;
  String? _audioPath;
  String? _aiAudioPath;
  List<Widget> _conversationComponents = [];

  bool _isFeedbackLoading = false;

  late AuthProvider authController =
      Provider.of<AuthProvider>(context, listen: false);
  late ValidateSentenceProvider validateSentenceProvider =
      Provider.of<ValidateSentenceProvider>(context, listen: false);
  late CallConversationProvider callConversationProvider =
      Provider.of<CallConversationProvider>(context, listen: false);

  late String userName = authController.user!.username ?? "username";
  late int userId = authController.user!.id ?? 123;
  late String _sessionId = widget.sessionId;

  @override
  void initState() {
    super.initState();

    audioPlayer = AudioPlayer();
    audioRecord = Record();

    setState(() {
      /*_dialogId = widget.dialogId.toString();
      _discussionTopic = widget.discussionTopic.toString();
      _discusTitle = widget.discusTitle.toString();
      _seqNumber = widget.seqNumber;*/
      _sessionId = widget.sessionId;
      _aiAudioPath = widget.agentAudio;
    });
    playRecording();
    _conversationComponents.add(firstConversation());
    _requestMicrophonePermission();
  }

  @override
  void dispose() {
    audioRecord.dispose();
    audioPlayer.dispose();
    super.dispose();
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
          _conversationComponents.add(
            AIResponseBox(audioFile!, _sessionId, userName),
          );
          /* playRecording();*/
        });
        // _isSuggestAnsActive = false;
        // suggestedAnswer = null;
      }
    } catch (e) {
      print("Error stop recording: $e");
    }
  }

  Future<void> playRecording() async {
    try {
      Source urlSource = UrlSource(_aiAudioPath!);
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

  Widget firstConversation() {
    Source urlSource = UrlSource(widget.agentName);
    // audioPlayer.play(urlSource);
    /*setState(() {
      latestQuestion = widget.conversationEn;
    });*/
    return Container(
      padding: EdgeInsets.all(5.0),
      child: Column(
        children: [
          /*AiName*/
          Row(
            children: [
              Expanded(
                flex: 7,
                child: Container(
                  padding: EdgeInsets.all(5.0),
                  // color: Colors.white,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                        child: Text(
                          widget.agentName,
                          // style: TextStyle(fontFamily: "Mina"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          /*Ai Row*/
          Row(
            children: [
              Expanded(
                flex: 6,
                child: Container(
                  padding: EdgeInsets.all(5.0),
                  // color: Colors.white,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color: AppColors.primaryColor.withOpacity(0.3),
                    ),
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      "${widget.firstText})",
                      // style: TextStyle(fontFamily: "Mina"),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        /*endDrawer: Drawer(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _conversationComponents,
            ),
          ),
        ),*/
        body: Container(
          decoration: BoxDecoration(
            color: AppColors.backgroundColorDark,
            image: DecorationImage(
              image: AssetImage("assets/images/caller_bg.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              /*Calling agent Info*/
              Container(
                margin: EdgeInsets.fromLTRB(0.0, 40.0, 0.0, 10.0),
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Image.asset(
                      "assets/images/profile_chat.png",
                      height: 100,
                      width: 100,
                    ),
                    Text(
                      widget.agentName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              /*control*/
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        elevation: 4,
                      ),
                      onPressed: () {},
                      icon: Container(
                        padding: EdgeInsets.all(10.0),
                        child: Icon(
                          Icons.info,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    IconButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        elevation: 4,
                      ),
                      onPressed: () {},
                      icon: Container(
                        padding: EdgeInsets.all(10.0),
                        child: Icon(
                          Icons.translate_rounded,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    IconButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        elevation: 4,
                      ),
                      onPressed: () {
                        /*_openEndDrawer();*/
                        setState(() {
                          _isChatExpanded = !_isChatExpanded;
                        });
                      },
                      icon: Container(
                        padding: EdgeInsets.all(10.0),
                        child: Icon(
                          Icons.message_rounded,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              /*Content*/
              AnimatedContainer(
                duration:
                    Duration(milliseconds: 300), // Set your animation duration
                curve: Curves.easeInOut,
                width: double.infinity,
                height: !_isChatExpanded ? 1 : 200,
                padding: EdgeInsets.all(10.0),
                margin: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: AppColors.backgroundColorDark,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: _conversationComponents,
                  ),
                ),
              ),
              /*Visibility(
                // visible:,
                child: Container(
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/images/risho_guru_icon.png",
                        width: 100,
                        height: 100,
                      ),
                      Text("Analyging"),
                    ],
                  ),
                ),
              ),*/
              Spacer(),
              /*Talk*/
              !_isChatExpanded
                  ? Column(
                      children: [
                        AvatarGlow(
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
                        SizedBox(
                          height: 10,
                        ),
                        /*End Call*/
                        Container(
                          width: double.infinity,
                          color: Colors.redAccent,
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.call_end,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    )
                  : Container(
                      width: MediaQuery.of(context).size.width - 5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          /*End Call*/
                          Flexible(
                            flex: 1,
                            child: Container(
                              width: double.infinity,
                              margin: EdgeInsets.fromLTRB(0.0, 5.0, 5.0, 5.0),
                              child: IconButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  backgroundColor: Colors.redAccent,
                                  elevation: 4,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Container(
                                  padding: EdgeInsets.all(10),
                                  child: Icon(
                                    Icons.call_end,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          /*Record*/
                          Flexible(
                            flex: 1,
                            child: Container(
                              width: double.infinity,
                              margin: EdgeInsets.fromLTRB(5.0, 5.0, 0.0, 5.0),
                              child: AvatarGlow(
                                animate: _isRecording,
                                curve: Curves.fastOutSlowIn,
                                glowColor: AppColors.primaryColor,
                                duration: const Duration(milliseconds: 1000),
                                repeat: true,
                                glowRadiusFactor: 1,
                                child: IconButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    backgroundColor: _isRecording == false
                                        ? Colors.white
                                        : AppColors.primaryColor,
                                    elevation: 4,
                                  ),
                                  onPressed: () async {
                                    if (!_isRecording) {
                                      await startRecording();
                                    } else {
                                      await stopRecording();
                                    }
                                    setState(() {});
                                  },
                                  icon: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Icon(
                                      _isRecording == false
                                          ? Icons.keyboard_voice_rounded
                                          : Icons.stop_rounded,
                                      color: _isRecording == false
                                          ? AppColors.primaryColor
                                          : Colors.white,
                                      size: 24,
                                    ),
                                  ),
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
    );
  }

  Widget AIResponseBox(File? audio, String? sessionId, String username) {
    print(sessionId);

    return FutureBuilder<void>(
        future: callConversationProvider.fetchCallConversationResponse(
          userId,
          widget.agentId,
          widget.sessionId,
          audio,
          username,
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
            String? aiDialog =
                callConversationProvider.callConversationResponse?.aiDialog;

            /*setState(() {
              latestQuestion = aiDialog;
            });*/
            // updateLatestQuestion(aiDialog);
            return buildAiResponse(context, snapshot);
          }
        });
  }

  Widget buildAiResponse(BuildContext context, AsyncSnapshot<void> snapshot) {
    if (snapshot.connectionState == ConnectionState.done) {
      String aiDialogAudio =
          callConversationProvider.callConversationResponse!.aiDialogAudio!;
      String aiDialogText =
          callConversationProvider.callConversationResponse!.aiDialog ?? "";
      String aiTranslation =
          callConversationProvider.callConversationResponse!.userTextBn ??
              "Not Found";
      double accuracyScore =
          callConversationProvider.callConversationResponse!.accuracyScore ??
              0.0;
      double fluencyScore =
          callConversationProvider.callConversationResponse!.fluencyScore ??
              0.0;
      double completenessScore = callConversationProvider
              .callConversationResponse!.completenessScore ??
          0.0;
      double prosodyScore =
          callConversationProvider.callConversationResponse!.prosodyScore ??
              0.0;

      List<WordScore>? words =
          callConversationProvider.callConversationResponse?.wordScores;

      String userText =
          callConversationProvider.callConversationResponse!.userText ?? "";
      String userTranslation =
          callConversationProvider.callConversationResponse!.userTextBn ??
              "Not Found";
      String userAudio =
          callConversationProvider.callConversationResponse!.userAudio!;

      /*int dialogId =
          callConversationProvider.callConversationResponse!.dialogId ??
              0;*/

      // _dialogId = dialogId.toString();
      // _seqNumber = seqNumber;
      // _discussionTopic = discussionTopic.toString();
      // _discusTitle = discusTitle.toString();
      _aiAudioPath = aiDialogAudio;

      Source urlSource = UrlSource(aiDialogAudio);
      audioPlayer.play(urlSource);
      return Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(5.0),
        child: Column(
          children: [
            /*UserRow*/
            userText != ""
                ? Column(
                    children: [
                      /*USERNAME*/
                      Row(
                        children: [
                          Expanded(
                            flex: 8,
                            child: Container(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                children: [
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
                                  Expanded(
                                    flex: 7,
                                    child: Text(
                                      userName,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      /*content*/
                      Row(
                        children: [
                          Flexible(
                            flex: 6,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                color:
                                    AppColors.secondaryColor.withOpacity(0.3),
                              ),
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                "$userText ( $userTranslation )",
                              ),
                            ),
                          ),
                          /*Flexible(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    */ /*Source urlSource =
                                        UrlSource(aiDialogAudio);
                                    audioPlayer.play(urlSource);*/ /*
                                  },
                                  icon: Icon(
                                    Icons.volume_down_rounded,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),*/
                        ],
                      ),
                      /*FEEDBACK*/
                      Container(
                        padding:
                            const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
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
                              child: Text(
                                "Feedback",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isFeedbackLoading = true;
                                });
                                ShowInfoDialog(
                                    userText,
                                    accuracyScore,
                                    fluencyScore,
                                    completenessScore,
                                    prosodyScore,
                                    words);
                                /*fetchDataAndShowBottomSheet(userText, "F")
                                  .whenComplete(() {
                                setState(() {
                                  _isFeedbackLoading = false;
                                });
                              });*/
                              },
                              child: Text(
                                "Accuracy",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
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
                      /*AI_NAME*/
                      Row(
                        children: [
                          Expanded(
                            flex: 7,
                            child: Container(
                              padding: EdgeInsets.all(5.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                                    child: Text(
                                      widget.agentName,
                                      // style: TextStyle(fontFamily: "Mina"),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      /*Content*/
                      Row(
                        children: [
                          Expanded(
                            flex: 6,
                            child: Container(
                              padding: EdgeInsets.all(5.0),
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.0),
                                      color: AppColors.primaryColor
                                          .withOpacity(0.3),
                                    ),
                                    padding: EdgeInsets.all(10.0),
                                    child: Text(
                                      "$aiDialogText",
                                      // style: TextStyle(fontFamily: "Mina"),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          /*Expanded(
                            flex: 1,
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
                                ],
                              ),
                            ),
                          ),*/
                        ],
                      ),
                    ],
                  )
                : SizedBox(
                    width: 2,
                  ),
          ],
        ),
      );
    } else {
      // While the future is still loading, return a loading indicator or placeholder
      return CircularProgressIndicator();
    }
  }

  Future ShowInfoDialog(
    String userText,
    double accuracyScore,
    double fluencyScore,
    double completenessScore,
    double prosodyScore,
    List<WordScore>? words,
  ) {
    print("words: ${words?[2].word}");
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
            padding: EdgeInsets.all(10.0),
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
                                  child:
                                      Text("${completenessScore.toString()}%"),
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
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: 10,
                    columns: [
                      DataColumn(label: Text('Word')),
                      DataColumn(label: Text('Accuracy Score')),
                      DataColumn(label: Text('Comments')),
                    ],
                    rows: words?.map((word) {
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
                ),
              ],
            ),
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
}
