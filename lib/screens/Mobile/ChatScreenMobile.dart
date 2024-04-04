import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';
import 'package:risho_speech/ui/colors.dart';

import '../../providers/doConversationProvider.dart';

class ChatScreenMobile extends StatefulWidget {
  const ChatScreenMobile({super.key});

  @override
  State<ChatScreenMobile> createState() => _ChatScreenMobileState();
}

class _ChatScreenMobileState extends State<ChatScreenMobile> {
  String? _audioPath;
  bool _isRecording = false;
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
  }

  Future<void> fetchSessionId() async {
    try {
      Map<String, dynamic> response = await doConversationProvider
          .fetchConversationResponse(59350, 2, '', null, '', '', '', '');
      setState(() {
        _conversationComponents.add(
          AIResponseBox(null, null),
        );
        sessionId = response['SessionID']; // Extract sessionId from response
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
          /*_conversationComponents.add(
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 2,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      playRecording();
                      print(_audioPath);
                    },
                    child: Text("Play recording"),
                  ),
                ],
              ),
            ),
          );*/
        });
        // await _convertToWav(_audioPath!);
      }
    } catch (e) {
      print("Error stop recording: $e");
    }
  }

  /*Future<void> _convertToWav(String inputPath) async {
    String outputPath = inputPath.replaceAll(RegExp(r'\.m4a*?$'), '.wav');
    await _flutterFFmpeg.execute('-i $inputPath $outputPath');
    setState(() {
      _audioPath = outputPath;
      audioFile = File(_audioPath!);
      _conversationComponents.add(AIResponseBox(audioFile!, sessionId));
    });
  }*/

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
                                .add(UserResponseBox(inputText));
                            _conversationComponents
                                .add(AIResponseBox(audioFile!, sessionId));

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
                doConversationProvider.conversationResponse!.aiDialogueAudio ??
                    "";
            String aiDialogText =
                doConversationProvider.conversationResponse!.aiDialogue ?? "";
            String userAudio =
                doConversationProvider.conversationResponse!.userAudio ?? "";
            String accuracyScore = doConversationProvider
                    .conversationResponse!.accuracyScore
                    .toString() ??
                "";
            String fluencyScore = doConversationProvider
                    .conversationResponse!.fluencyScore
                    .toString() ??
                "";
            String completenessScore = doConversationProvider
                    .conversationResponse!.completenessScore
                    .toString() ??
                "";
            String prosodyScore = doConversationProvider
                    .conversationResponse!.prosodyScore
                    .toString() ??
                "";
            String userText =
                doConversationProvider.conversationResponse!.userText ?? "";

            Source urlSource = UrlSource(aiDialogAudio);
            audioPlayer.play(urlSource);
            return Container(
              padding: EdgeInsets.all(5.0),
              child: Column(
                children: [
                  /*UserRow*/
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return Container(
                                        width: double.infinity,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text("Accuracy Score:"),
                                                Text(accuracyScore),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text("Fluency Score:"),
                                                Text(fluencyScore),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text("Completeness Score:"),
                                                Text(completenessScore),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
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
                                },
                                icon: const Icon(
                                  Icons.info_outline,
                                  color: Colors.white,
                                ),
                              ),
                              IconButton(
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
                                      userText,
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
                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return Container(
                                  width: double.infinity,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "CorrectSentence: ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text("CORRECT"),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Explanation: ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text("EXPLAINATION"),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Alternate Sentence: ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text("ALTERNATE"),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Bangla Explanation: ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text("BANGLA"),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          child: Text("Feedback"),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
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

  Widget UserResponseBox(String text) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Container(),
          ),
          Expanded(
            flex: 7,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: AppColors.secondaryColor.withOpacity(0.3),
              ),
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 8,
                    child: Text(
                      text,
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
          ),
        ],
      ),
    );
  }
}
