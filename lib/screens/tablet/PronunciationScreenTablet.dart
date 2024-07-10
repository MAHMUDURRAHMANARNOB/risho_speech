import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';
import 'package:risho_speech/models/doGuidedConverationDataModel.dart';
import 'package:risho_speech/providers/doGuidedConversationProvider.dart';
import 'package:risho_speech/ui/colors.dart';
import 'package:shimmer/shimmer.dart';

import '../../models/validateSpokenSentenceDataModel.dart';
import '../../providers/auth_provider.dart';
import '../../providers/nextQuestionProvider.dart';
import '../../providers/validateSpokenSentenceProvider.dart';
import '../packages_screen.dart';

class PronunciationScreenTablet extends StatefulWidget {
  final int conversationId;
  final int dialogId;
  final String conversationEn;
  final String conversationBn;
  final String conversationAudioFile;
  final int seqNumber;
  final String conversationDetails;
  final String discussionTopic;
  final String discusTitle;
  final String actorName;

  const PronunciationScreenTablet(
      {super.key,
      required this.conversationId,
      required this.dialogId,
      required this.conversationEn,
      required this.conversationBn,
      required this.conversationAudioFile,
      required this.seqNumber,
      required this.conversationDetails,
      required this.discussionTopic,
      required this.discusTitle,
      required this.actorName});

  @override
  State<PronunciationScreenTablet> createState() =>
      _PronunciationScreenTabletState();
}

class _PronunciationScreenTabletState extends State<PronunciationScreenTablet> {
  bool _isFeedbackLoading = false;

  bool _isRecording = false;
  late Record audioRecord;
  late AudioPlayer audioPlayer;
  List<Widget> _conversationComponents = [];
  File? audioFile;
  late String? latestQuestion;

  late String? _dialogId;
  late int? _seqNumber;
  late String? _discussionTopic;
  late String? _discusTitle;

  String? _audioPath;

  late DoGuidedConversationProvider doGuidedConversationProvider =
      Provider.of<DoGuidedConversationProvider>(context, listen: false);
  late NextQuestionProvider nextQuestionProvider =
      Provider.of<NextQuestionProvider>(context, listen: false);
  late AuthProvider authController =
      Provider.of<AuthProvider>(context, listen: false);
  late ValidateSentenceProvider validateSentenceProvider =
      Provider.of<ValidateSentenceProvider>(context, listen: false);

  late String userName = authController.user!.username ?? "username";
  late int userId = authController.user!.id ?? 123;

  @override
  void initState() {
    super.initState();

    audioPlayer = AudioPlayer();
    audioRecord = Record();
    setState(() {
      _dialogId = widget.dialogId.toString();
      _discussionTopic = widget.discussionTopic.toString();
      _discusTitle = widget.discusTitle.toString();
      _seqNumber = widget.seqNumber;
    });
    _requestMicrophonePermission();
    _conversationComponents.add(firstConversation());
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
            AIResponseBox(audioFile!, _dialogId, userName),
          );
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

  Widget firstConversation() {
    Source urlSource = UrlSource(widget.conversationAudioFile);
    audioPlayer.play(urlSource);
    setState(() {
      latestQuestion = widget.conversationEn;
    });
    return Container(
      padding: EdgeInsets.all(5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
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
                          widget.actorName,
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
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
            child: Row(
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
                        "${widget.conversationEn} ( ${widget.conversationBn} )",
                        // style: TextStyle(fontFamily: "Mina"),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                Source urlSource =
                                    UrlSource(widget.conversationAudioFile);
                                audioPlayer.play(urlSource);
                              },
                              icon: Icon(
                                Icons.volume_down_rounded,
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
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final username =
        Provider.of<AuthProvider>(context).user?.name ?? 'UserName';
    userId = Provider.of<AuthProvider>(context).user?.id ?? 123;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryCardColor,
        title: Text(
          widget.discusTitle,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          /*Top*/
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: _conversationComponents,
              ),
            ),
          ),

          /*BottomControl*/
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
                    /*Expanded(
                      flex: 1,
                      child: SizedBox(
                        width: 20,
                      ),
                    ),*/
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
                    /*Expanded(
                      flex: 1,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                          ),
                          onPressed: () {},
                          child: const Text(
                            "Next",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),*/
                  ],
                ),
                Text(
                  "You have to say the Text ${widget.actorName} is saying",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      // bottomSheet: BottomSection(),
    );
  }

  Widget AIResponseBox(File? audio, String? sessionId, String username) {
    print(sessionId);

    return FutureBuilder<void>(
        future: doGuidedConversationProvider.fetchGuidedConversationResponse(
            userId,
            widget.conversationId,
            _dialogId.toString(),
            audio,
            _discussionTopic,
            _discusTitle,
            '',
            username,
            _seqNumber),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            /*return const SpinKitThreeInOut(
              color: AppColors.primaryColor,
            ); */ // Loading state
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
            String aiDialog = doGuidedConversationProvider
                .guidedConversationResponse!.conversationEn!;

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
      int errorCode =
          doGuidedConversationProvider.guidedConversationResponse!.error!;
      if (errorCode == 200) {
        String aiDialogAudio = doGuidedConversationProvider
            .guidedConversationResponse!.conversationAudioFile!;
        String aiDialogText = doGuidedConversationProvider
                .guidedConversationResponse!.conversationEn ??
            "";
        // String userAudio = doGuidedConversationProvider.guidedConversationResponse!.userAudio!;
        double accuracyScore = doGuidedConversationProvider
                .guidedConversationResponse!.accuracyScore ??
            0.0;
        double fluencyScore = doGuidedConversationProvider
                .guidedConversationResponse!.fluencyScore ??
            0.0;
        double completenessScore = doGuidedConversationProvider
                .guidedConversationResponse!.completenessScore ??
            0.0;
        double prosodyScore = doGuidedConversationProvider
                .guidedConversationResponse!.prosodyScore ??
            0.0;

        List<WordInfo>? words =
            doGuidedConversationProvider.guidedConversationResponse?.words;

        String userText = doGuidedConversationProvider
                .guidedConversationResponse!.speechText ??
            "";
        String userTranslation = doGuidedConversationProvider
                .guidedConversationResponse!.speechTextBn ??
            "Not Found";
        String aiTranslation = doGuidedConversationProvider
                .guidedConversationResponse!.conversationBn ??
            "Not Found";

        int dialogId =
            doGuidedConversationProvider.guidedConversationResponse!.dialogId ??
                0;
        int seqNumber = doGuidedConversationProvider
                .guidedConversationResponse!.seqNumber ??
            0;
        String discussionTopic = doGuidedConversationProvider
                .guidedConversationResponse!.discussionTopic ??
            "null";
        String discusTitle = doGuidedConversationProvider
                .guidedConversationResponse!.discusTitle ??
            "null";

        _dialogId = dialogId.toString();
        _seqNumber = seqNumber;
        _discussionTopic = discussionTopic.toString();
        _discusTitle = discusTitle.toString();

        Source urlSource = UrlSource(aiDialogAudio);
        audioPlayer.play(urlSource);
        return Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(5.0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
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
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                          child: Row(
                            children: [
                              Flexible(
                                flex: 6,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.0),
                                    color: AppColors.secondaryColor
                                        .withOpacity(0.3),
                                  ),
                                  padding: EdgeInsets.all(10.0),
                                  child: Text(
                                    "$userText ( $userTranslation )",
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        /*Source urlSource =
                                          UrlSource(aiDialogAudio);
                                      audioPlayer.play(urlSource);*/
                                      },
                                      icon: Icon(
                                        Icons.volume_down_rounded,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
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
                        /*AI NAME*/
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
                                          "assets/images/risho_guru_icon.png",
                                          height: 30,
                                          width: 30,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 7,
                                      child: Text(
                                        widget.actorName,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        /*Content*/
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                          child: Row(
                            children: [
                              Flexible(
                                flex: 6,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.0),
                                    color:
                                        AppColors.primaryColor.withOpacity(0.3),
                                  ),
                                  padding: EdgeInsets.all(10.0),
                                  child: Text(
                                    "$aiDialogText ( $aiTranslation )",
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        /*Source urlSource =
                                          UrlSource(aiDialogAudio);
                                      audioPlayer.play(urlSource);*/
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
                            ],
                          ),
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
                  "Sorry: ${doGuidedConversationProvider.guidedConversationResponse!.message}",
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
          padding: const EdgeInsets.all(12.0),
          child: Text(
              doGuidedConversationProvider.guidedConversationResponse!.message),
        );
      }
    } else {
      // While the future is still loading, return a loading indicator or placeholder
      return const CircularProgressIndicator();
    }
  }

  Future ShowInfoDialog(
    String userText,
    double accuracyScore,
    double fluencyScore,
    double completenessScore,
    double prosodyScore,
    List<WordInfo>? words,
  ) {
    print("words: ${words?[2].word}");
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
                margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      userText,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                                        value: accuracyScore / 100,
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
                                      child:
                                          Text("${accuracyScore.toString()}%"),
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
                                        value: fluencyScore / 100,
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
                                      child:
                                          Text("${fluencyScore.toString()}%"),
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
                                        value: completenessScore / 100,
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
                                          "${completenessScore.toString()}%"),
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
                                        value: prosodyScore / 100,
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
                                      child:
                                          Text("${prosodyScore.toString()}%"),
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
}
