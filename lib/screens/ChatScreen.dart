import 'package:flutter/material.dart';
import 'package:risho_speech/screens/tablet/ChatScreenTablet.dart';

import '../responsive/responsive_layout.dart';
import 'Mobile/ChatScreenMobile.dart';

class ChatScreen extends StatefulWidget {
  final int id;
  final String sessionId;
  final String aiDialogue;
  final String aiDialogueAudio;
  final String aiTranslation;
  final String actorName;
  final String isFemale;

  ChatScreen(
      {super.key,
      required this.id,
      required this.sessionId,
      required this.aiDialogue,
      required this.aiDialogueAudio,
      required this.aiTranslation,
      required this.actorName,
      required this.isFemale});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileScaffold: ChatScreenMobile(
          id: widget.id,
          sessionId: widget.sessionId,
          aiDialogue: widget.aiDialogue,
          aiDialogueAudio: widget.aiDialogueAudio,
          aiTranslation: widget.aiTranslation,
          actorName: widget.actorName,
          isFemale: widget.isFemale,
        ),
        tabletScaffold: ChatScreenTablet(
          id: widget.id,
          sessionId: widget.sessionId,
          aiDialogue: widget.aiDialogue,
          aiDialogueAudio: widget.aiDialogueAudio,
          aiTranslation: widget.aiTranslation,
          actorName: widget.actorName,
          isFemale: widget.isFemale,
        ),
        desktopScaffold: ChatScreenTablet(
          id: widget.id,
          sessionId: widget.sessionId,
          aiDialogue: widget.aiDialogue,
          aiDialogueAudio: widget.aiDialogueAudio,
          aiTranslation: widget.aiTranslation,
          actorName: widget.actorName,
          isFemale: widget.isFemale,
        ),
      ),
    );
  }
}
