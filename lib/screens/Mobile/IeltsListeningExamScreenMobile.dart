import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconsax/iconsax.dart';
import 'package:just_audio/just_audio.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:provider/provider.dart';
import 'package:risho_speech/providers/endIeltsListeningExamPrivider.dart';
import 'package:risho_speech/screens/ExamAnalysisScreen.dart';

import '../../providers/auth_provider.dart';
import '../../providers/ieltsListeningExamQuestionProvider.dart';
import '../../ui/colors.dart';

class IeltsListeningExamScreenMobile extends StatefulWidget {
  /*final String audioFile, question;
  final int examId;*/

  const IeltsListeningExamScreenMobile({
    super.key,
    /*required this.audioFile,
      required this.question,
      required this.examId*/
  });

  @override
  State<IeltsListeningExamScreenMobile> createState() =>
      _IeltsListeningExamScreenMobileState();
}

class _IeltsListeningExamScreenMobileState
    extends State<IeltsListeningExamScreenMobile>
    with SingleTickerProviderStateMixin {
  final GlobalKey<_answerSheetState> _answerSheetKey =
      GlobalKey<_answerSheetState>();
  bool _isSubmitAnsLoading = false;
  bool isLoading = true;
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
    /*setState(() {
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
    });*/
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchInitialData();
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
      /* setState(() {*/
      isLoading = false; // Set the flag to false once data is loaded

      /*});*/
    } else {
      throw Exception('Failed to load exam data');
    }
  }

  late final userId;
  int initialTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    final userId = Provider.of<AuthProvider>(context).user?.id ?? 1;

    return Scaffold(
      appBar: AppBar(
        title: Text("IELTS Listening Test"),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator()) // Show loader while loading
          : Column(
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
                                ? Icon(Iconsax.pause,
                                    color: AppColors.primaryColor)
                                : Icon(Iconsax.play,
                                    color: AppColors.primaryColor),
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
                    initialIndex: initialTabIndex,
                    length: 2, // Number of tabs
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        questionPanel(
                            key: ValueKey(listeningPart),
                            question: questionListening),
                        answerSheet(
                            key: _answerSheetKey, listeningPart: listeningPart),
                      ],
                    ),
                  ),
                ),

                // Submit button at the very bottom to call the next section
                /*GestureDetector(
                  onTap: () async {
                    final answerSheetState = _answerSheetKey.currentState;
                    if (answerSheetState != null) {
                      */ /*String? ansJsonString =
                          answerSheetState.convertAndPrintAnswers();*/ /*
                      String? ansJsonString = answerSheetState
                          .convertAndPrintAnswers((listeningPart - 1) * 10);
                      if (ansJsonString == null) {
                        Fluttertoast.showToast(msg: "Please fill all answers.");
                        await _showMyDialog();
                        return; // Prevent further execution if any answer is empty
                      }

                      if (listeningPart < 5) {
                        setState(() {
                          listeningPart++;
                        });
                      }

                      if (listeningPart <= 4) {
                        // Call the Provider and proceed with the logic as before
                        final provider = Provider.of<IeltsListeningProvider>(
                            context,
                            listen: false);
                        final response = await provider.getIeltsListeningExam(
                          userId: userId,
                          listeningPart: listeningPart,
                          tokenUsed: 1,
                          ansJson: ansJsonString,
                          examinationId: examIdListening,
                        );

                        if (response['errorcode'] == 200) {
                          setState(() {
                            audioFileListening = provider
                                .listeningAudioQuestionResponse!.audioFile;
                            questionListening = provider
                                .listeningAudioQuestionResponse!.question;
                          });

                          // Reset controllers for the next set of questions
                          answerSheetState.resetControllers();

                          await player.setUrl(audioFileListening);
                          setState(() {
                            position = Duration.zero;
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Error: ${response['message']}')),
                          );
                        }
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ExamAnalysisScreen()),
                        );
                      }
                    }
                  },
                  child: Visibility(
                    visible: listeningPart <= 4,
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
                ),*/
                GestureDetector(
                  onTap: () async {
                    setState(() {
                      _isSubmitAnsLoading = true; // Show the loader
                    });
                    // Show loading dialog
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      // Prevent dismissing the dialog by tapping outside
                      builder: (BuildContext context) {
                        return Dialog(
                          backgroundColor: Colors.transparent,
                          // Make background transparent
                          child: Center(
                            child: CircularProgressIndicator(), // Loader widget
                          ),
                        );
                      },
                    );

                    final answerSheetState = _answerSheetKey.currentState;
                    if (answerSheetState != null) {
                      // Get the answers and validate
                      String? ansJsonString = answerSheetState
                          .convertAndPrintAnswers((listeningPart - 1) * 10);
                      if (ansJsonString == null) {
                        // Show the toast and dialog if answers are missing

                        await _showErrorDialog(); // Ensure that the dialog is shown
                        setState(() {
                          _isSubmitAnsLoading = false; // Hide the loader
                        });
                        Navigator.pop(context);
                        return; // Prevent further execution
                      }

                      if (listeningPart < 5) {
                        // Increment listeningPart if it's less than 5
                        setState(() {
                          listeningPart++;
                          initialTabIndex = 0;
                        });
                      }

                      if (listeningPart <= 4) {
                        // Call the provider and proceed with the logic

                        final provider = Provider.of<IeltsListeningProvider>(
                            context,
                            listen: false);
                        final response = await provider.getIeltsListeningExam(
                          userId: userId,
                          listeningPart: listeningPart,
                          tokenUsed: 1,
                          ansJson: ansJsonString,
                          examinationId: examIdListening,
                        );

                        if (response['errorcode'] == 200) {
                          // Update the UI with new questions and reset controllers
                          setState(() {
                            audioFileListening = provider
                                .listeningAudioQuestionResponse!.audioFile;
                            questionListening = provider
                                .listeningAudioQuestionResponse!.question;
                          });
                          Fluttertoast.showToast(
                            msg: "Success. Proceeding to the next one",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.TOP,
                            backgroundColor: AppColors.primaryColor,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );

                          /*listeningPart++;*/

                          // Reset the answer sheet for the next set of questions
                          answerSheetState.resetControllers();

                          // Update the audio player
                          await player.setUrl(audioFileListening);
                          setState(() {
                            position = Duration.zero;
                          });
                        } else {
                          // Handle the error (e.g., show a dialog or a snackbar)
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Error: ${response['message']}')),
                          );
                        }
                      } else {
                        // Navigate to the Exam Analysis Screen
                        /*Fluttertoast.showToast(
                          msg: "why is it coming?",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.TOP,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );*/
                        final provider = Provider.of<EndIeltsListeningProvider>(
                            context,
                            listen: false);
                        final response = await provider.endIeltsListeningExam(
                          userId: userId,
                          ansJson: ansJsonString,
                          examinationId: examIdListening,
                        );
                        print(response.toString());
                        String jsonString = jsonEncode(response.toString());
                        setState(() {
                          _isSubmitAnsLoading = false; // Hide the loader
                        });
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ExamAnalysisScreen(listeningData: response),
                          ),
                        );
                      }
                    } else {
                      print("AnswerSheetState is null");
                      _showErrorDialog();
                    }
                    setState(() {
                      _isSubmitAnsLoading = false; // Hide the loader
                    });
                    Navigator.pop(context);
                  },
                  child: Visibility(
                    visible: listeningPart <= 4,
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
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
                // Display loader
                if (_isSubmitAnsLoading)
                  Center(
                    child: CircularProgressIndicator(), // Loader widget
                  ),
              ],
            ),
    );
  }

  Future<void> _showErrorDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'OOPS!',
            textAlign: TextAlign.center,
            style:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent),
          ),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'You have to Complete all the Answers before submitting.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor2),
              child: const Text(
                'Ok',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
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
  final int listeningPart;

  const answerSheet({super.key, required this.listeningPart});

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
  String? convertAndPrintAnswers(int baseIndex) {
    List<String> answers = getValues();
    // Check if any answer is empty
    if (answers.any((answer) => answer.trim().isEmpty)) {
      return null; // Return null if any answer is empty
    }
    Map<String, String> answersMap = {
      for (int i = 0; i < answers.length; i++)
        '${baseIndex + i + 1}': answers[i]
    };

    String jsonString = jsonEncode(answersMap);
    // print(jsonString);
    return jsonString;
  }

  void resetControllers() {
    for (var controller in _controllers) {
      controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final int baseIndex = (widget.listeningPart - 1) * 10;

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
                  Text("${baseIndex + index + 1}. ",
                      style: TextStyle(fontSize: 16.0)),
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
