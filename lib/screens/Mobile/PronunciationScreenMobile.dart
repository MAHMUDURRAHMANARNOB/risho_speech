import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:provider/provider.dart';
import 'package:risho_speech/models/doGuidedConverationDataModel.dart';
import 'package:risho_speech/providers/doGuidedConversationProvider.dart';
import 'package:risho_speech/screens/Dashboard.dart';
import 'package:risho_speech/screens/HomeScreen.dart';
import 'package:risho_speech/ui/colors.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:shimmer/shimmer.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../../models/validateSpokenSentenceDataModel.dart';
import '../../providers/auth_provider.dart';
import '../../providers/nextQuestionProvider.dart';
import '../../providers/validateSpokenSentenceProvider.dart';
import '../packages_screen.dart';

class PronunciationScreenMobile extends StatefulWidget {
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

  const PronunciationScreenMobile({
    super.key,
    required this.conversationId,
    required this.dialogId,
    required this.conversationEn,
    required this.conversationBn,
    required this.conversationAudioFile,
    required this.seqNumber,
    required this.conversationDetails,
    required this.discussionTopic,
    required this.discusTitle,
    required this.actorName,
  });

  @override
  State<PronunciationScreenMobile> createState() =>
      _PronunciationScreenMobileState();
}

class _PronunciationScreenMobileState extends State<PronunciationScreenMobile> {
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
    _pageController.dispose();
    super.dispose();
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
    List<Widget> _tempConversationComponents = [];

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
            print("Recorded file path: $_audioPath");
            _tempConversationComponents
                .add(AIResponseBox(audioFile!, _dialogId, userName));
            _tempConversationComponents.addAll(_conversationComponents);
            /*_conversationComponents.add(
            AIResponseBox(audioFile!, _dialogId, userName),
          );*/
            _conversationComponents = _tempConversationComponents;
          });
          // _isSuggestAnsActive = false;
          // suggestedAnswer = null;
        } else {
          setState(() {
            _isRecording = false;
          });
          print("File not found at path: $path");
        }
      } else {
        print("Permission denied for microphone");
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
        children: [
          /*Ai Row*/
          Stack(
            children: [
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color: AppColors.backgroundColorDark.withOpacity(0.3),
                      border: Border.all(width: 1.0, color: Colors.white),
                    ),
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "${widget.conversationEn}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 20.0),
                        ),
                        SizedBox(height: 20.0),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Bangla: ",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            Expanded(
                              child: Text(
                                "${widget.conversationBn}",
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 16),
                                // style: TextStyle(fontFamily: "Mina"),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryColor),
                              onPressed: () {
                                Source urlSource =
                                    UrlSource(widget.conversationAudioFile);
                                audioPlayer.play(urlSource);
                              },
                              icon: Icon(
                                IconsaxPlusBold.headphone,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                left: 15,
                top: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  color: AppColors.backgroundColorDark,
                  child: Row(
                    children: [
                      Icon(
                        Iconsax.book,
                        size: 18,
                        color: AppColors.secondaryColor,
                      ),
                      SizedBox(width: 5.0),
                      Text(
                        'Tap on Mic & Read',
                        style: TextStyle(
                          color: AppColors.secondaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
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

  PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final username =
        Provider.of<AuthProvider>(context).user?.name ?? 'UserName';
    userId = Provider.of<AuthProvider>(context).user?.id ?? 123;

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.backgroundColorDark,
        appBar: AppBar(
          // backgroundColor: AppColors.primaryCardColor,
          title: Text(
            widget.discusTitle,
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              /*Top*/
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: _conversationComponents /*.reversed.toList()*/,
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
                child: Row(
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
              ),
            ],
          ),
        ),
        // bottomSheet: BottomSection(),
      ),
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
            );*/ // Loading state
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
            String aiDialog = doGuidedConversationProvider
                .guidedConversationResponse!.conversationEn!;
            if (kDebugMode) {
              print("aiDialog - $aiDialog");
            }
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
          doGuidedConversationProvider.guidedConversationResponse!.error;
      if (errorCode == 200) {
        String aiDialogAudio = doGuidedConversationProvider
            .guidedConversationResponse!.conversationAudioFile!;
        String aiDialogText = doGuidedConversationProvider
                .guidedConversationResponse!.conversationEn ??
            "";
        String userAudio =
            doGuidedConversationProvider.guidedConversationResponse!.fileLoc!;
        double pronScore = doGuidedConversationProvider
                .guidedConversationResponse!.pronScore ??
            0.0;
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
        if (kDebugMode) {
          print("userText - $userText");
        }

        String userTranslation = doGuidedConversationProvider
                .guidedConversationResponse!.speechTextBn ??
            "Not Found";
        if (kDebugMode) {
          print("userTranslation - $userTranslation");
        }
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

        return Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(5.0),
          child: Column(
            children: [
              /*Ai Row*/
              aiDialogText != ""
                  ? Stack(
                      children: [
                        Column(
                          children: [
                            /*Content*/
                            Container(
                              margin: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                color: AppColors.backgroundColorDark
                                    .withOpacity(0.3),
                                border:
                                    Border.all(width: 1.0, color: Colors.white),
                              ),
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "${aiDialogText}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 20.0),
                                  ),
                                  SizedBox(height: 20.0),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Bangla: ",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Expanded(
                                        child: Text(
                                          "${aiTranslation}",
                                          style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 16),
                                          // style: TextStyle(fontFamily: "Mina"),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                AppColors.primaryColor),
                                        onPressed: () {
                                          Source urlSource =
                                              UrlSource(aiDialogAudio);
                                          audioPlayer.play(urlSource);
                                        },
                                        icon: Icon(
                                          IconsaxPlusBold.headphone,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          left: 15,
                          top: 0,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            color: AppColors.backgroundColorDark,
                            child: Row(
                              children: [
                                Icon(Iconsax.book,
                                    size: 18, color: AppColors.secondaryColor),
                                SizedBox(width: 5.0),
                                Text(
                                  'Tap on Mic & Read',
                                  style: TextStyle(
                                    color: AppColors.secondaryColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  : SizedBox(
                      width: 2,
                    ),
              /*UserRow*/
              userText != ""
                  ? Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              margin: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                border: Border.all(
                                    width: 1.0, color: AppColors.primaryColor),
                                color: /*AppColors.primaryColor2.withOpacity(
                                    0.3) */
                                    AppColors.backgroundColorDark,
                              ),
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "$userText \n( $userTranslation )",
                                        ),
                                      ),
                                      IconButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                AppColors.primaryColor),
                                        onPressed: () {
                                          Source urlSource =
                                              UrlSource(userAudio);
                                          audioPlayer.play(urlSource);
                                        },
                                        icon: Icon(
                                          IconsaxPlusBold.headphone,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5.0),
                                  Container(
                                    width: double.infinity,
                                    child: Column(
                                      /*mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,*/
                                      children: [
                                        Row(
                                          children: [
                                            ScoringWidget(
                                                title: "Accuracy",
                                                score: accuracyScore),
                                            ScoringWidget(
                                                title: "Fluency",
                                                score: fluencyScore),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            ScoringWidget(
                                                title: "Completeness",
                                                score: completenessScore),
                                            ScoringWidget(
                                                title: "Prosody",
                                                score: prosodyScore),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  /*FEEDBACK & Accuracy*/
                                  Container(
                                    padding: const EdgeInsets.fromLTRB(
                                        10.0, 10.0, 10.0, 0.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        /*ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Colors.white.withOpacity(0.3),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _isFeedbackLoading = true;
                                            });
                                            fetchDataAndShowBottomSheet(
                                                    userText, "F")
                                                .whenComplete(() {
                                              setState(() {
                                                _isFeedbackLoading = false;
                                              });
                                            });
                                          },
                                          child: const Text(
                                            "Check Grammar",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),*/
                                        SizedBox(),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                AppColors.primaryColor,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _isFeedbackLoading = true;
                                            });
                                            ShowInfoDialog(
                                                userText,
                                                pronScore,
                                                accuracyScore,
                                                fluencyScore,
                                                completenessScore,
                                                prosodyScore,
                                                words);
                                          },
                                          child: Text(
                                            "Pronunciation details",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
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
                        Positioned(
                          left: 15,
                          top: 0,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            color: AppColors.backgroundColorDark,
                            child: Row(
                              children: [
                                Icon(
                                  Iconsax.microphone,
                                  size: 18,
                                  color: AppColors.primaryColor,
                                ),
                                SizedBox(width: 5.0),
                                Text(
                                  'Your Response',
                                  style: TextStyle(
                                    color: AppColors.primaryColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
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
              SizedBox(height: 10.0),
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
      } else if (errorCode == 410) {
        _showSessionExpiredDialog();
        return SizedBox();
      } else {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: AppColors.secondaryColor.withOpacity(0.1),
          ),
          padding: EdgeInsets.all(10.0),
          child: Text(doGuidedConversationProvider
                  .guidedConversationResponse!.message ??
              "404: There might be some issues with your Internet connection.Please try again after sometime."),
        );
      }
    } else {
      // While the future is still loading, return a loading indicator or placeholder
      return CircularProgressIndicator();
    }
  }

  void _showSessionExpiredDialog() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        barrierDismissible: false,
        // Prevents dialog from closing when tapping outside
        builder: (BuildContext context) {
          return AlertDialog(
            title: Image.asset(
              "assets/images/target.gif",
              width: 200,
              height: 200,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Congratulations',
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'You have successfully completed the lesson',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Dismiss the dialog
                  Navigator.pushReplacement<void, void>(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => const Dashboard(),
                    ),
                  );
                },
                child: Text(
                  'OK',
                  style: TextStyle(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        },
      );
    });
  }

  Future ShowInfoDialog(
    String userText,
    double pronScore,
    double accuracyScore,
    double fluencyScore,
    double completenessScore,
    double prosodyScore,
    List<WordInfo>? words,
  ) {
    print("words: ${words?[2].word}");
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
                  margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        userText,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
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
                                        child: Text(
                                            "${accuracyScore.toString()}%"),
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
              builder:
                  (BuildContext context, ScrollController scrollController) {
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
              });
        }
      },
    );
  }
}

class ScoringWidget extends StatelessWidget {
  const ScoringWidget({
    super.key,
    required this.score,
    required this.title,
  });

  final double score;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomLeft,
            colors: [
              Colors.transparent,
              // Start with a transparent color
              AppColors.primaryColor.withOpacity(0.1),
              // Adjust opacity as needed
            ],
          ),
          border: Border.all(
            color: AppColors.primaryColor,
            width: 0.5,
          ),
        ),
        padding: const EdgeInsets.all(5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.left,
              ),
            ),
            const SizedBox(width: 8.0),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  child: CircularProgressIndicator(
                    value: score / 100,
                    strokeWidth: 4,
                    backgroundColor: Colors.grey[300],
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
                  ),
                ),
                Text(
                  '${score.toInt()}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
