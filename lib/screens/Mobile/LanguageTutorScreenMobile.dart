import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:audioplayers/audioplayers.dart';
import 'package:avatar_glow/avatar_glow.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iconsax/iconsax.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import 'package:markdown_widget/markdown_widget.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';
import 'package:risho_speech/models/tutorSpokenCourseDataModel.dart';
import 'package:risho_speech/providers/LanguageTutorResponseProvider.dart';
import 'package:shimmer/shimmer.dart';

import '../../models/LanguageTutorResponseDataModel.dart';
import '../../providers/auth_provider.dart';
import '../../ui/colors.dart';
import '../Dashboard.dart';
import '../packages_screen.dart';

class LanguageTutorScreenMobile extends StatefulWidget {
  final LanguageTutorSuccessResponse tutorResponse;
  final String languageName;

  const LanguageTutorScreenMobile(
      {super.key, required this.tutorResponse, required this.languageName});

  @override
  State<LanguageTutorScreenMobile> createState() =>
      _LanguageTutorScreenMobileState();
}

late String chapterTitle;
late String lessonTitle;
late int lessonCount;
late String courseId;
late String aiDialog;
late String aiDialogAudio;
late String langName;

class _LanguageTutorScreenMobileState extends State<LanguageTutorScreenMobile> {
  PageController _pageController = PageController();
  Record audioRecord = Record();
  bool _isRecording = false;

  late AudioPlayer audioPlayer;
  List<Widget> _conversationComponents = [];

  File? audioFile;
  late String? latestQuestion;

  String? _audioPath;

  late LanguageTutorResponseProvider languageTutorResponseProvider =
      Provider.of<LanguageTutorResponseProvider>(context, listen: false);

  late AuthProvider authController =
      Provider.of<AuthProvider>(context, listen: false);

  late String userName = authController.user!.username ?? "username";
  late String fullName = authController.user!.name ?? "username";
  late int userId = authController.user!.id ?? 123;

  @override
  void initState() {
    super.initState();

    audioPlayer = AudioPlayer();
    audioRecord = Record();
    setState(() {
      chapterTitle = widget.tutorResponse.chapterTitle;
      lessonTitle = widget.tutorResponse.lessonTitle;
      lessonCount = widget.tutorResponse.lessonCount;
      aiDialog = widget.tutorResponse.aiDialogue;
      aiDialogAudio = widget.tutorResponse.aiDialogueAudio;
      langName = widget.languageName;
      /*_dialogId = widget.dialogId.toString();
      _discussionTopic = widget.discussionTopic.toString();
      _discusTitle = widget.discusTitle.toString();
      _seqNumber = widget.seqNumber;*/
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
            /*_tempConversationComponents
                .add(AIResponseBox(audioFile!, userId, userName));
            _tempConversationComponents.addAll(_conversationComponents);*/
            /*_conversationComponents.add(
            AIResponseBox(audioFile!, _dialogId, userName),
          );*/
            _conversationComponents.add(
                AIResponseBox(audioFile!, userId, fullName, "N", langName));
          });
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
    // Check current microphone permission status
    final status = await Permission.microphone.status;

    if (status.isGranted) {
      // Permission is already granted, proceed to use microphone
      print('Microphone permission already granted');
    } else if (status.isDenied) {
      // Permission is denied but can be requested again
      final newStatus = await Permission.microphone.request();
      if (newStatus.isGranted) {
        print('Microphone permission granted');
        // Proceed to use microphone
      } else if (newStatus.isDenied) {
        // The user denied the permission again, give them a reason
        _showPermissionRationale();
      }
    } else if (status.isPermanentlyDenied) {
      // Permission is permanently denied, the user must manually enable it
      _showSettingsDialog();
    }
  }

  void _showPermissionRationale() {
    // Show a dialog explaining why the app needs the microphone
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Microphone Permission Needed'),
          content: Text(
            'The microphone is required for this feature. Please allow microphone access in the next prompt.',
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Request Again'),
              onPressed: () {
                Navigator.of(context).pop();
                _requestMicrophonePermission(); // Request permission again
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showSettingsDialog() {
    // Show a dialog guiding the user to the Settings app manually
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Microphone Permission Needed'),
          content: Text(
            'Microphone access is required for this feature. Please enable it in your app settings.',
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Open Settings'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                openAppSettings(); // Open Settings app
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget firstConversation() {
    Source urlSource = UrlSource(aiDialogAudio);
    audioPlayer.play(urlSource);
    setState(() {
      latestQuestion = aiDialog;
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
                    width: double.infinity,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset(
                              "assets/images/risho_guru_icon.png",
                              width: 50,
                              height: 50,
                            ),
                            IconButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryColor),
                              onPressed: () {
                                Source urlSource = UrlSource(aiDialogAudio);
                                audioPlayer.play(urlSource);
                              },
                              icon: const Icon(
                                IconsaxPlusBold.headphone,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.0),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MarkdownWidget(
                            data: aiDialog ?? "No content available",
                            shrinkWrap: true,
                            selectable: true,
                            config: MarkdownConfig.defaultConfig,
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
                  child: Text(
                    'Listen and Answer',
                    style: TextStyle(
                      color: AppColors.secondaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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
        backgroundColor: AppColors.backgroundColorDark,
        appBar: AppBar(
          title: const Text(
            "Learn with Tutor",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              /*Top*/
              Container(
                padding: EdgeInsets.all(5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text("Chapter: $chapterTitle"),
                    RichText(
                      text: TextSpan(
                        text: 'Lesson: ',
                        style: TextStyle(
                            color: AppColors.secondaryColor,
                            fontWeight: FontWeight.bold),
                        children: <TextSpan>[
                          TextSpan(
                              text: lessonTitle,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    )
                    /*Text(
                      "Lesson: $lessonTitle",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),*/
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: _conversationComponents /*.reversed.toList()*/,
                  ),
                ),
              ),

              /*BottomControl*/

              Stack(
                children: [
                  if (!_isRecording)
                    Align(
                      alignment: Alignment.center,
                      child: IconButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
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
                        icon: const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Icon(
                            Iconsax.microphone,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  else
                    Align(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AvatarGlow(
                            animate: _isRecording,
                            curve: Curves.fastOutSlowIn,
                            glowColor: AppColors.primaryColor,
                            duration: const Duration(milliseconds: 1000),
                            repeat: true,
                            glowRadiusFactor: 1,
                            child: IconButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryColor),
                              onPressed: () async {
                                // Add your logic to send the message
                                if (!_isRecording) {
                                  await startRecording();
                                } else {
                                  await stopRecording();
                                }
                                setState(() {});
                              },
                              icon: const Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Icon(
                                  Iconsax.stop,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10.0),
                          IconButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent),
                            onPressed: () async {
                              _clearRecording();
                            },
                            icon: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Icon(
                                Iconsax.trash,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  Positioned(
                    right: 2,
                    bottom: 10,
                    child: Visibility(
                      visible: lessonCount > 19,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryCardColor,
                              ),
                              onPressed: () {
                                setState(() {
                                  _conversationComponents.add(AIResponseBox(
                                      null, userId, fullName, "Y", langName));
                                });
                              },
                              child: const Row(
                                children: [
                                  Text(
                                    "Next",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  SizedBox(width: 5),
                                  Icon(
                                    IconsaxPlusBold.direct_right,
                                    color: AppColors.primaryColor,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget AIResponseBox(File? audio, int userId, String username,
      String nextLesson, String? langName) {
    // print(sessionId);

    return FutureBuilder<void>(
        future: languageTutorResponseProvider.fetchLanguageTutorResponse(
            userId, username, null, audio, nextLesson, langName),
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
            String aiDialog =
                languageTutorResponseProvider.successResponse!.aiDialogue!;

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
      int errorCode = languageTutorResponseProvider.successResponse!.errorCode;
      if (errorCode == 200) {
        String aiDialogAudio =
            languageTutorResponseProvider.successResponse!.aiDialogueAudio!;
        String aiDialogText =
            languageTutorResponseProvider.successResponse!.aiDialogue ?? "";
        String userAudio =
            languageTutorResponseProvider.successResponse!.userAudioFile!;

        String userText =
            languageTutorResponseProvider.successResponse!.userText;
        lessonTitle =
            languageTutorResponseProvider.successResponse!.lessonTitle;
        chapterTitle =
            languageTutorResponseProvider.successResponse!.chapterTitle;
        lessonCount =
            languageTutorResponseProvider.successResponse!.lessonCount;

        _audioPath = aiDialogAudio;

        // String userTranslation = tutorResponseProvider.successResponse!.userText;

        // List<WordInfo>? words = tutorResponseProvider.successResponse?.words;

        if (kDebugMode) {
          print("userText - $userText");
        }
        if (kDebugMode) {
          print("lessonCount - $lessonCount");
        }
        Source urlSource = UrlSource(aiDialogAudio);
        audioPlayer.play(urlSource);
        return Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(5.0),
          child: Column(
            children: [
              /*SizedBox(height: 10.0),*/
              /*Ai Row*/
              aiDialogText != ""
                  ? Stack(
                      children: [
                        Column(
                          children: [
                            /*Content*/
                            Container(
                              width: double.infinity,
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
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Image.asset(
                                        "assets/images/risho_guru_icon.png",
                                        width: 50,
                                        height: 50,
                                      ),
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
                                    ],
                                  ),
                                  SizedBox(height: 10.0),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: MarkdownWidget(
                                      data: aiDialogText,
                                      shrinkWrap: true,
                                      selectable: true,
                                      config: MarkdownConfig.defaultConfig,
                                    ),
                                  ),

                                  /*Text(
                                    "${aiDialogText}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 16.0),
                                  ),*/
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
                            child: Text(
                              'Listen and Answer',
                              style: TextStyle(
                                color: AppColors.secondaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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
                  "Sorry: ${languageTutorResponseProvider.successResponse!.message}",
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
          child: Text(languageTutorResponseProvider.successResponse!.message ??
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
            content: const Column(
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

  void _clearRecording() {
    setState(() {
      _isRecording = false;
      _audioPath = null;
      // Clear recording logic here
    });
  }
}
