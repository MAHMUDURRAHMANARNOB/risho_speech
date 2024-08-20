import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
  const IeltsListeningExamScreenMobile({Key? key}) : super(key: key);

  @override
  State<IeltsListeningExamScreenMobile> createState() =>
      _IeltsListeningExamScreenMobileState();
}

class _IeltsListeningExamScreenMobileState
    extends State<IeltsListeningExamScreenMobile>
    with SingleTickerProviderStateMixin {
  /*final GlobalKey<_AnswerSheetState> _answerSheetKey =
      GlobalKey<_AnswerSheetState>();*/
  final AudioPlayer _player = AudioPlayer();
  late TabController _tabController;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  int _listeningPart = 1;
  bool _isLoading = true;
  bool _isSubmitAnsLoading = false;

  late final List<TextEditingController> _textControllers;

  late IeltsListeningProvider _ieltsListeningProvider;
  String? _audioFileListening;
  String? _questionListening;
  int? _examIdListening;
  int _initialTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _textControllers = List.generate(10, (index) => TextEditingController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchInitialData();
    });
  }

  @override
  void dispose() {
    _player.dispose();
    _tabController.dispose();
    for (var controller in _textControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  String? convertAndPrintAnswers(int startingIndex) {
    final answers = _textControllers.map((c) => c.text.trim()).toList();
    if (answers.contains('')) return null;

    final answerMap = {
      for (int i = 0; i < answers.length; i++)
        '${startingIndex + i + 1}': answers[i]
    };
    return json.encode(answerMap);
  }

  void resetControllers() {
    for (var controller in _textControllers) {
      controller.clear();
    }
  }

  Widget _buildAnswerSheet() {
    final int baseIndex = (_listeningPart - 1) * 10;
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  "${(baseIndex + index + 1)}.",
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              Expanded(
                flex: 5,
                child: TextField(
                  cursorColor: AppColors.primaryColor,
                  controller: _textControllers[index],
                  decoration: const InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          width: 2,
                          color: AppColors.primaryColor), //<-- SEE HERE
                    ),
                    hintText: 'Enter your answer',
                    border: UnderlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _fetchInitialData() async {
    _ieltsListeningProvider =
        Provider.of<IeltsListeningProvider>(context, listen: false);
    final userId =
        Provider.of<AuthProvider>(context, listen: false).user?.id ?? 1;

    final response = await _ieltsListeningProvider.getIeltsListeningExam(
      userId: userId,
      listeningPart: _listeningPart,
      tokenUsed: 1,
      ansJson: '',
      examinationId: null,
    );

    if (response['errorcode'] == 200) {
      _audioFileListening =
          _ieltsListeningProvider.listeningAudioQuestionResponse!.audioFile;
      _questionListening =
          _ieltsListeningProvider.listeningAudioQuestionResponse!.question;
      _examIdListening =
          _ieltsListeningProvider.listeningAudioQuestionResponse!.examId;

      await _player.setUrl(_audioFileListening!);
      _player.positionStream.listen((p) {
        setState(() {
          _position = p;
        });
      });

      _player.durationStream.listen((d) {
        if (d != null) {
          setState(() {
            _duration = d;
          });
        }
      });

      setState(() {
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load exam data');
    }
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60);
    final seconds = d.inSeconds.remainder(60);
    return "${minutes.toString().padLeft(2, '0')} : ${seconds.toString().padLeft(2, '0')}";
  }

  void _handlePlayPause() {
    if (_player.playing) {
      _player.pause();
    } else {
      _player.play();
    }
  }

  void _handleSeek(double value) {
    _player.seek(Duration(seconds: value.toInt()));
  }

  Future<void> _submitAnswers() async {
    setState(() {
      _isSubmitAnsLoading = true;
    });

    /*final answerSheetState = _answerSheetKey.currentState;
    if (answerSheetState == null) {
      print("AnswerSheetState is null");
      _showErrorDialog("Please fill all answers.");
    } else {*/
    // Get answers and validate
    String? ansJsonString = convertAndPrintAnswers((_listeningPart - 1) * 10);
    if (ansJsonString == null) {
      await _showErrorDialog('Please fill all answers.');
      setState(() {
        _isSubmitAnsLoading = false;
      });
      return;
    }
    /*if (_listeningPart < 5) {
        setState(() {
          _listeningPart++;
        });
      }*/
    // Handle different listening parts
    if (_listeningPart < 4) {
      final response = await _ieltsListeningProvider.getIeltsListeningExam(
        userId: Provider.of<AuthProvider>(context, listen: false).user?.id ?? 1,
        listeningPart: _listeningPart + 1,
        tokenUsed: 1,
        ansJson: ansJsonString,
        examinationId: _examIdListening,
      );

      if (response['errorcode'] == 200) {
        setState(() {
          _audioFileListening =
              _ieltsListeningProvider.listeningAudioQuestionResponse!.audioFile;
          _questionListening =
              _ieltsListeningProvider.listeningAudioQuestionResponse!.question;
          // _listeningPart++;
          _listeningPart++;
          _initialTabIndex = 0;
        });

        // Reset answer sheet
        resetControllers();
        await _player.setUrl(_audioFileListening!);
        setState(() {
          _position = Duration.zero;
        });
      } else {
        Fluttertoast.showToast(
          msg: "Error: ${response['message']}",
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
        );
      }
    } else {
      final endProvider =
          Provider.of<EndIeltsListeningProvider>(context, listen: false);
      final response = await endProvider.endIeltsListeningExam(
        userId: Provider.of<AuthProvider>(context, listen: false).user?.id ?? 1,
        ansJson: ansJsonString,
        examinationId: _examIdListening,
      );
      setState(() {
        _isSubmitAnsLoading = false; // Hide the loader
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ExamAnalysisScreen(listeningData: response),
        ),
      );
    }
    /* }*/

    setState(() {
      _isSubmitAnsLoading = false;
    });
  }

  Future<void> _showErrorDialog(String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'OOPS!',
            textAlign: TextAlign.center,
            style:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor2),
              child: const Text('Ok', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("IELTS Listening Test"),
      ),
      body: _isLoading
          ? const Center(
              child: SpinKitThreeInOut(color: AppColors.primaryColor))
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    "Listening Part $_listeningPart",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                _buildAudioPlayer(),
                _buildTabBar(),
                _buildTabBarView(),
                if (!_isSubmitAnsLoading && _listeningPart <= 4)
                  _buildSubmitButton(),
                if (_isSubmitAnsLoading)
                  const Center(
                      child: SpinKitThreeInOut(color: AppColors.primaryColor)),
              ],
            ),
    );
  }

  Widget _buildAudioPlayer() {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_formatDuration(_position)),
              Text(_formatDuration(_duration)),
            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: _handlePlayPause,
                icon: Icon(
                  _player.playing ? Iconsax.pause : Iconsax.play,
                  color: AppColors.primaryColor,
                ),
              ),
              Flexible(
                child: Slider(
                  activeColor: AppColors.primaryColor,
                  min: 0.0,
                  max: _duration.inSeconds.toDouble(),
                  value: _position.inSeconds
                      .toDouble()
                      .clamp(0.0, _duration.inSeconds.toDouble()),
                  onChanged: (value) => _handleSeek(value),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      controller: _tabController,
      indicatorColor: AppColors.primaryColor,
      labelColor: AppColors.primaryColor,
      unselectedLabelColor: Colors.white,
      tabs: const [
        Tab(text: 'Question'),
        Tab(text: 'Answer Sheet'),
      ],
    );
  }

  Widget _buildTabBarView() {
    return Expanded(
      child: TabBarView(
        controller: _tabController,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: MarkdownWidget(data: _questionListening ?? ''),
          ),
          /*AnswerSheet(
            key: _answerSheetKey,
            initialPart: _listeningPart,
          ),*/
          _buildAnswerSheet(),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor2,
          minimumSize: const Size.fromHeight(50),
        ),
        onPressed: _submitAnswers,
        child: const Text(
          'Submit Answers',
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

/*class AnswerSheet extends StatefulWidget {
  final int initialPart;

  const AnswerSheet({Key? key, required this.initialPart}) : super(key: key);

  @override
  _AnswerSheetState createState() => _AnswerSheetState();
}

class _AnswerSheetState extends State<AnswerSheet> {
  late final List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(10, (index) => TextEditingController());
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  String? convertAndPrintAnswers(int startingIndex) {
    final answers = _controllers.map((c) => c.text.trim()).toList();
    if (answers.contains('')) return null;

    final answerMap = {
      for (int i = 0; i < answers.length; i++)
        '${startingIndex + i + 1}': answers[i]
    };
    return json.encode(answerMap);
  }

  void resetControllers() {
    for (var controller in _controllers) {
      controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  "${index + 1}.",
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              Expanded(
                flex: 5,
                child: TextField(
                  controller: _controllers[index],
                  decoration: InputDecoration(
                    hintText: 'Enter your answer',
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}*/
