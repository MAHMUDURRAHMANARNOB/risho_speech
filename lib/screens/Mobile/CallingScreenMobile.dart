import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';
import 'package:risho_speech/providers/callAndConversationProvider.dart';
import 'package:risho_speech/ui/colors.dart';

import '../../providers/auth_provider.dart';
import '../../providers/validateSpokenSentenceProvider.dart';

class CallingScreenMobile extends StatefulWidget {
  final String agentId;
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
  bool _isRecording = false;
  late Record audioRecord;
  late AudioPlayer audioPlayer;
  File? audioFile;
  String? _audioPath;
  List<Widget> _conversationComponents = [];

  late AuthProvider authController =
      Provider.of<AuthProvider>(context, listen: false);
  late ValidateSentenceProvider validateSentenceProvider =
      Provider.of<ValidateSentenceProvider>(context, listen: false);
  late CallConversationProvider callConversationProvider =
      Provider.of<CallConversationProvider>(context, listen: false);

  late String userName = authController.user!.username ?? "username";
  late int userId = authController.user!.id ?? 123;

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
      _audioPath = widget.agentAudio;
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
          /*_conversationComponents.add(
            AIResponseBox(audioFile!, _dialogId, userName),
          );*/
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
                      onPressed: () {},
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
              Container(
                width: double.infinity,
                height: 100,
                padding: EdgeInsets.all(10.0),
                margin: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: AppColors.secondaryCardColorGreenish,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: _conversationComponents,
                  ),
                ),
              ),
              Spacer(),
              /*Talk*/
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
              /*Center(
                child: Text(
                    "${widget.agentId} -- ${widget.agentName} -- ${widget.sessionId}"),
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}
