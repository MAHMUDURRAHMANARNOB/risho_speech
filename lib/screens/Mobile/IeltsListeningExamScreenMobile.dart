import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:just_audio/just_audio.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/ieltsListeningExamQuestionProvider.dart';
import '../../ui/colors.dart';

class IeltsListeningExamScreenMobile extends StatefulWidget {
  final String audioFile, question;
  final int examId;

  const IeltsListeningExamScreenMobile(
      {super.key,
      required this.audioFile,
      required this.question,
      required this.examId});

  @override
  State<IeltsListeningExamScreenMobile> createState() =>
      _IeltsListeningExamScreenMobileState();
}

class _IeltsListeningExamScreenMobileState
    extends State<IeltsListeningExamScreenMobile>
    with SingleTickerProviderStateMixin {
  final GlobalKey<_answerSheetState> _answerSheetKey =
      GlobalKey<_answerSheetState>();

  final player = AudioPlayer();
  late TabController _tabController;

  var audioFileListening;
  var questionListening;
  var examIdListening;
  int listeningPart = 1;

  late IeltsListeningProvider ieltsListeningProvider =
      Provider.of<IeltsListeningProvider>(context, listen: false);

  String formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60);
    final seconds = d.inSeconds.remainder(60);
    return "${minutes.toString().padLeft(2, '0')} : ${seconds.toString().padLeft(2, '0')}";
  }

  void handlePlayPause() {
    if (player.playing) {
      player.pause();
    } else {
      player.play();
    }
  }

  void handleSeek(double value) {
    player.seek(Duration(seconds: value.toInt()));
  }

  Duration position = Duration.zero;
  Duration duration = Duration.zero;

  @override
  void initState() {
    super.initState();
    setState(() {
      audioFileListening = widget.audioFile;
      questionListening = widget.question;
      examIdListening = widget.examId;
    });

    player.setUrl(audioFileListening);

    //   Listen to the position updates
    player.positionStream.listen((p) {
      setState(() {
        position = p;
      });
    });

    player.durationStream.listen((d) {
      setState(() {
        duration = d!;
      });
    });

    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    player.dispose();
    _tabController.dispose();
    listeningPart = 1;
    super.dispose();
  }

  Future<void> fetchInitialData() async {
    final userId =
        Provider.of<AuthProvider>(context, listen: false).user?.id ?? 1;

    final response = await ieltsListeningProvider.getIeltsListeningExam(
      userId: userId,
      listeningPart: listeningPart,
      tokenUsed: 1,
      ansJson: '',
      examinationId: null,
    );

    if (response['errorcode'] == 200) {
      audioFileListening =
          ieltsListeningProvider.listeningAudioQuestionResponse!.audioFile;
      questionListening =
          ieltsListeningProvider.listeningAudioQuestionResponse!.question;
      examIdListening =
          ieltsListeningProvider.listeningAudioQuestionResponse!.examId;
      await player.setUrl(audioFileListening);
      player.positionStream.listen((p) {
        setState(() {
          position = p;
        });
      });

      player.durationStream.listen((d) {
        setState(() {
          duration = d!;
        });
      });
    } else {
      throw Exception('Failed to load exam data');
    }
  }

  late final userId;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    final userId = Provider.of<AuthProvider>(context).user?.id ?? 1;

    return Scaffold(
      appBar: AppBar(
        title: Text("IELTS Listening Test"),
      ),
      body: Container(
          child: Column(
        children: [
          Text("Listening Part $listeningPart"),
          // Audio
          Container(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: [
                // Audio timing
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(formatDuration(position)),
                    Text(formatDuration(duration)),
                  ],
                ),
                // Audio part
                Row(
                  children: [
                    IconButton(
                      onPressed: handlePlayPause,
                      icon: player.playing
                          ? Icon(Iconsax.pause, color: AppColors.primaryColor)
                          : Icon(Iconsax.play, color: AppColors.primaryColor),
                    ),
                    Flexible(
                      flex: 1,
                      child: Slider(
                        activeColor: AppColors.primaryColor,
                        min: 0.0,
                        max: duration.inSeconds.toDouble(),
                        value: position.inSeconds
                            .toDouble()
                            .clamp(0.0, duration.inSeconds.toDouble()),
                        onChanged: handleSeek,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          TabBar(
            controller: _tabController,
            indicatorColor: AppColors.primaryColor,
            labelColor: AppColors.primaryColor,
            unselectedLabelColor: Colors.white,
            tabs: <Widget>[
              Tab(text: "Question"),
              Tab(text: "Answer Sheet"),
            ],
          ),
          // Question and Answer Tab
          Expanded(
            flex: 1,
            child: DefaultTabController(
              initialIndex: 0,
              length: 2, // Number of tabs
              child: TabBarView(
                controller: _tabController,
                children: [
                  Expanded(child: questionPanel(question: questionListening)),
                  Expanded(child: answerSheet(key: _answerSheetKey)),
                ],
              ),
            ),
          ),

          // Submit button at the very bottom to call the next section
          GestureDetector(
            onTap: () async {
              final answerSheetState = _answerSheetKey.currentState;
              if (answerSheetState != null) {
                answerSheetState.convertAndPrintAnswers();
              }
              String? ansJsonString =
                  answerSheetState?.convertAndPrintAnswers();
              print("hi i am $ansJsonString");

              // Call the Provider
              final provider =
                  Provider.of<IeltsListeningProvider>(context, listen: false);

              // Call the API and wait for the result
              final response = await provider.getIeltsListeningExam(
                userId: userId,
                listeningPart: listeningPart,
                tokenUsed: 1,
                ansJson: ansJsonString,
                examinationId: examIdListening,
              );
              if (response['errorcode'] == 200) {
                setState(() {
                  audioFileListening =
                      provider.listeningAudioQuestionResponse!.audioFile;
                  questionListening =
                      provider.listeningAudioQuestionResponse!.question;
                  examIdListening =
                      provider.listeningAudioQuestionResponse!.examId;
                  listeningPart++;
                });

                // Update the audio player with the new audio file
                await player.setUrl(audioFileListening);
                // Optionally reset the position and duration
                setState(() {
                  position = Duration.zero;
                  // duration = Duration.zero;
                });
              } else {
                // Handle the error (e.g., show a dialog or a snackbar)
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: ${response['message']}')),
                );
              }
            },
            child: Container(
              width: double.infinity,
              color: AppColors.primaryColor2,
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                "Submit",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
          ),
        ],
      )),
    );
  }
}

class questionPanel extends StatefulWidget {
  final String question;

  const questionPanel({super.key, required this.question});

  @override
  State<questionPanel> createState() => _qustionPanelState();
}

class _qustionPanelState extends State<questionPanel> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(8.0),
        height: screenHeight,
        child: MarkdownWidget(
          data: widget.question,
        ),
      ),
    );
  }
}

class answerSheet extends StatefulWidget {
  const answerSheet({super.key});

  @override
  State<answerSheet> createState() => _answerSheetState();
}

class _answerSheetState extends State<answerSheet> {
  List<TextEditingController> _controllers = List.generate(
    10,
    (index) => TextEditingController(),
  );

  @override
  void dispose() {
    // Dispose controllers when widget is disposed
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  // Method to retrieve values from the text fields
  List<String> getValues() {
    return _controllers.map((controller) => controller.text).toList();
  }

  // Method to convert answers to JSON format and print
  String convertAndPrintAnswers() {
    List<String> answers = getValues();
    Map<String, String> answersMap = {
      for (int i = 0; i < answers.length; i++) '${i + 1}': answers[i]
    };
    String jsonString = jsonEncode(answersMap);
    print(jsonString);
    return jsonString;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: List.generate(
            10,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("${index + 1}. ", style: TextStyle(fontSize: 16.0)),
                  Expanded(
                    child: TextField(
                      cursorColor: AppColors.primaryColor,
                      controller: _controllers[index],
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: AppColors
                                  .primaryColor), // Customize color when focused
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
