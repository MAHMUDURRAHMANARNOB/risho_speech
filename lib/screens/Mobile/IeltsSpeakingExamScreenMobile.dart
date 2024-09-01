import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:just_audio/just_audio.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:provider/provider.dart';
import 'package:risho_speech/screens/SpeakingTestReportScreen.dart';
import 'package:risho_speech/ui/colors.dart';
import 'package:record/record.dart';
import '../../models/speakingExamDataModel.dart';
import '../../providers/auth_provider.dart';
import '../../providers/speakingExamProvider.dart';
import '../../utils/audio_related/audio_visualized.dart';
import '../Common/AiEmotionWidget.dart';

class IeltsSpeakingExamScreenMobile extends StatefulWidget {
  const IeltsSpeakingExamScreenMobile({super.key});

  @override
  State<IeltsSpeakingExamScreenMobile> createState() =>
      _IeltsSpeakingExamScreenMobileState();
}

class _IeltsSpeakingExamScreenMobileState
    extends State<IeltsSpeakingExamScreenMobile> {
  bool _isRecording = false;
  late Record audioRecord;
  String? _audioPath;
  File? _recordedFile;
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    audioRecord = Record();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchExamData();
    });
    // _fetchExamData();
  }

  late int examID;
  late int userId;
  late String? examAudio;
  late String? cueCardTopic;
  late int examStage = 1;
  late String isFemale = "F";
  double _amplitude = 0.0;

  bool _isAiListening = false;

  Future<void> _fetchExamData() async {
    userId = Provider.of<AuthProvider>(context, listen: false).user?.id ?? 1;
    final speakingExamProvider =
        Provider.of<IeltsSpeakingExamProvider>(context, listen: false);
    final response = await speakingExamProvider.fetchIeltsSpeakingExam(
      userId: userId,
      // replace with the actual user ID
      examinationId: null,
      // replace with the actual examination ID
      examStage: examStage,
      // initial exam stage
      audioFile: null,

      // no audio file at the start
      isFemale: "", // replace with the actual gender info
    );
    print(response.toString());

    // Play audio once data is fetched and audio URL is available
    if (response['errorcode'] == 200 &&
        speakingExamProvider.examResponse != null &&
        speakingExamProvider.examResponse!.aiDialogAudio!.isNotEmpty) {
      examID = speakingExamProvider.examResponse!.examId;
      examAudio = speakingExamProvider.examResponse!.aiDialogAudio;
      cueCardTopic = speakingExamProvider.examResponse!.cueCardTopics;
      examStage = speakingExamProvider.examResponse!.examStage;
      isFemale = speakingExamProvider.examResponse!.isFemale;

      /*_audioPlayer.setUrl(examAudio!);
      _audioPlayer.play();
      _startListeningToAudio();*/
      if (speakingExamProvider.examResponse!.aiDialogAudio != null) {
        speakingExamProvider.playAudioFromURL(
            speakingExamProvider.examResponse!.aiDialogAudio!);
      }
    }
  }

  void _startListeningToAudio() {
    _audioPlayer.positionStream.listen((position) async {
      // You would typically extract the amplitude from the audio here.
      // This example uses a dummy amplitude value.
      setState(() {
        _amplitude = (position.inMilliseconds % 1000) / 1000.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "IELTS Speaking Test",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Consumer<IeltsSpeakingExamProvider>(
        builder: (context, provider, child) {
          if (provider.examResponse == null) {
            return Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryColor,
              ),
            );
          }

          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Stage Determiner
                Text(
                  "Part - ${examStage}",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: screenHeight * 0.04,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      // Cue Card Topic -- Only visible for stage 2
                      if (provider.examResponse!.examStage == 2)
                        Container(
                          padding: const EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24.0),
                            color: AppColors.vocabularyCatCardColor,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Cue Card Topic",
                                style: TextStyle(
                                    fontSize: screenHeight * 0.016,
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: screenHeight * 0.02),
                              Visibility(
                                visible: cueCardTopic != null,
                                child: Container(
                                  height: screenHeight * 0.10,
                                  child: MarkdownWidget(
                                    data: cueCardTopic!,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                /*Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      AudioVisualizer(
                        audioPlayer: _audioPlayer,
                        isRecording: _isRecording,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                    ],
                  ),
                ),*/
                SizedBox(height: screenHeight * 0.04),
                Consumer<IeltsSpeakingExamProvider>(
                  builder: (context, provider, _) {
                    return Column(
                      children: [
                        AiEmotionWidget(
                          // Use the AiEmotionWidget
                          isAiSaying: provider.isAiSaying,
                          isAiAnalyzing: provider.isAiAnalyging,
                          isAiListening: _isAiListening,
                          isAiWaiting: provider.isAiWaiting,
                          AIName: "Trainer",
                          AIGander: isFemale,
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(
                  height: screenHeight * 0.01,
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Microphone button for telling
                      if (!_isRecording)
                        IconButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            elevation: 4,
                          ),
                          onPressed: _startRecording,
                          icon: const Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Icon(
                              Iconsax.microphone,
                              color: Colors.white,
                            ),
                          ),
                        )
                      else
                        Row(
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
                                onPressed: _pauseRecording,
                                icon: const Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: Icon(
                                    Iconsax.stop,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 20.0),
                            IconButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent),
                              onPressed: _clearRecording,
                              icon: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Icon(
                                  Iconsax.trash,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      SizedBox(height: screenHeight * 0.02),
                    ],
                  ),
                ),
                //   Cancel Test
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 15,
                    ),
                  ),
                  onPressed: _cancelTest,
                  child: Text(
                    "Cancel Test",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _startRecording() {
    audioRecord.start();
    setState(() {
      _isRecording = true;
      _isAiListening = true;
      // Start recording logic here
    });
  }

  void _pauseRecording() async {
    String? path = await audioRecord.stop();
    setState(() {
      _isRecording = false;
      _audioPath = path;
      _recordedFile = File(_audioPath!);
      print(_audioPath);
      _isAiListening = false;

      // _isAiListening = false;

      /* playRecording();*/
    });

    // Call the API with the recorded file
    final speakingExamProvider =
        Provider.of<IeltsSpeakingExamProvider>(context, listen: false);
    final response = await speakingExamProvider.fetchIeltsSpeakingExam(
      userId: userId,
      // replace with actual user ID
      examinationId: examID,
      // replace with actual examination ID
      examStage: examStage,
      audioFile: _recordedFile,
      // replace with the actual recorded file
      isFemale: isFemale,
    );

    if (response['errorcode'] == 200 &&
        speakingExamProvider.examResponse != null) {
      if (response['report'] != null) {
        // Navigate to the ReportScreen to show the full report
        final report = Report.fromJson(response['report']);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SpeakingTestReportScreen(
              report: report,
            ),
          ),
        );
      } else {
        examID = speakingExamProvider.examResponse!.examId;
        examAudio = speakingExamProvider.examResponse!.aiDialogAudio;
        cueCardTopic = speakingExamProvider.examResponse!.cueCardTopics;
        examStage = speakingExamProvider.examResponse!.examStage;
        isFemale = speakingExamProvider.examResponse!.isFemale;

        /*_audioPlayer.setUrl(examAudio!);
        _audioPlayer.play();
        _startListeningToAudio();*/
        if (speakingExamProvider.examResponse!.aiDialogAudio != null) {
          speakingExamProvider.playAudioFromURL(
              speakingExamProvider.examResponse!.aiDialogAudio!);
        }
      }
    }
  }

  void _clearRecording() {
    setState(() {
      _isRecording = false;
      _recordedFile = null;
      // Clear recording logic here
    });
  }

  void _cancelTest() {
    // Cancel test logic here

    _audioPlayer.stop();
    Navigator.pop(context);
  }
}
