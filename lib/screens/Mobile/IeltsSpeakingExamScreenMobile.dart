import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:just_audio/just_audio.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:provider/provider.dart';
import 'package:risho_speech/screens/SpeakingTestReportScreen.dart';
import 'package:risho_speech/ui/colors.dart';

import '../../providers/auth_provider.dart';
import '../../providers/speakingExamProvider.dart';
import '../../utils/audio_related/audio_visualized.dart';

class IeltsSpeakingExamScreenMobile extends StatefulWidget {
  const IeltsSpeakingExamScreenMobile({super.key});

  @override
  State<IeltsSpeakingExamScreenMobile> createState() =>
      _IeltsSpeakingExamScreenMobileState();
}

class _IeltsSpeakingExamScreenMobileState
    extends State<IeltsSpeakingExamScreenMobile> {
  // late SiriWaveformController _siriWaveController;

  bool _isRecording = false;
  File? _recordedFile;
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    /*_siriWaveController = SiriWaveController(
      amplitude: 0,
      speed: 0.1,
    );*/
    _fetchExamData();
  }

  late int examID;
  late int userId;
  late String? examAudio;
  late String? cueCardTopic;
  late int examStage = 1;
  late String isFemale;
  double _amplitude = 0.0;

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
        speakingExamProvider.examResponse!.aiDialogAudio.isNotEmpty) {
      examID = speakingExamProvider.examResponse!.examId;
      examAudio = speakingExamProvider.examResponse!.aiDialogAudio;
      cueCardTopic = speakingExamProvider.examResponse!.cueCardTopics;
      examStage = speakingExamProvider.examResponse!.examStage;
      isFemale = speakingExamProvider.examResponse!.isFemale;

      _audioPlayer.setUrl(examAudio!);
      _audioPlayer.play();
      _startListeningToAudio();
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "IELTS Speaking Test",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: /*Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Stage Determiner
            Text(
              "Stage - 1",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20.0),
            // Cue Card Topic -- Only visible for stage 2
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.0),
                color: AppColors.vocabularyCatCardColor,
              ),
              child: Column(
                children: [
                  Text(
                    "Cue Card Topic",
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    "Describe a time when you were really proud of yourself.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            // Microphone button for telling
            IconButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor),
              onPressed: () {},
              icon: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Icon(
                  Iconsax.microphone,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 20.0),
            //   Cancel Test
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 15,
                ),
              ),
              onPressed: () {},
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
      ),*/
          Consumer<IeltsSpeakingExamProvider>(
        builder: (context, provider, child) {
          if (provider.examResponse == null) {
            return Center(child: CircularProgressIndicator());
          }

          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      // Stage Determiner
                      Text(
                        "Stage - ${examStage}",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20.0),

                      // Cue Card Topic -- Only visible for stage 2
                      if (provider.examResponse!.examStage == 2)
                        Container(
                          padding: const EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24.0),
                            color: AppColors.vocabularyCatCardColor,
                          ),
                          child: Column(
                            children: [
                              Text(
                                "Cue Card Topic",
                                style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 20.0),
                              Visibility(
                                visible: cueCardTopic != null,
                                child: Container(
                                  height: 40.0,
                                  child: MarkdownWidget(
                                    data: cueCardTopic!,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      SizedBox(height: 20.0),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
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
                          icon: Padding(
                            padding: const EdgeInsets.all(20.0),
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
                                icon: Padding(
                                  padding: const EdgeInsets.all(20.0),
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
                      SizedBox(height: 20.0),
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
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _startRecording() {
    setState(() {
      _isRecording = true;
      // Start recording logic here
    });
  }

  void _pauseRecording() async {
    setState(() {
      _isRecording = false;
      // Pause recording logic here
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
        speakingExamProvider.examResponse != null &&
        speakingExamProvider.examResponse!.aiDialogAudio.isNotEmpty) {
      if (response['report'] != null) {
        // Navigate to the ReportScreen to show the full report
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SpeakingTestReportScreen(
              report: response['report'],
            ),
          ),
        );
      } else {
        examID = speakingExamProvider.examResponse!.examId;
        examAudio = speakingExamProvider.examResponse!.aiDialogAudio;
        cueCardTopic = speakingExamProvider.examResponse!.cueCardTopics;
        examStage = speakingExamProvider.examResponse!.examStage;
        isFemale = speakingExamProvider.examResponse!.isFemale;

        _audioPlayer.setUrl(examAudio!);
        _audioPlayer.play();
        _startListeningToAudio();
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
