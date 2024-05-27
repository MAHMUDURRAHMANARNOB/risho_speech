import 'package:flutter/material.dart';
import 'package:risho_speech/screens/tablet/PronunciationScreenTablet.dart';

import '../responsive/responsive_layout.dart';
import 'Mobile/PronunciationScreenMobile.dart';

class PronunciationScreen extends StatefulWidget {
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

  PronunciationScreen(
      {super.key,
      required this.conversationId,
      required this.dialogId,
      required this.conversationEn,
      required this.conversationBn,
      required this.conversationAudioFile,
      required this.seqNumber,
      required this.conversationDetails,
      required this.discussionTopic,
      required this.discusTitle,
      required this.actorName});

  @override
  State<PronunciationScreen> createState() => _PronunciationScreenState();
}

class _PronunciationScreenState extends State<PronunciationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileScaffold: PronunciationScreenMobile(
          conversationId: widget.conversationId,
          dialogId: widget.dialogId,
          conversationEn: widget.conversationEn,
          conversationBn: widget.conversationBn,
          conversationAudioFile: widget.conversationAudioFile,
          seqNumber: widget.seqNumber,
          conversationDetails: widget.conversationDetails,
          discussionTopic: widget.discussionTopic,
          discusTitle: widget.discusTitle,
          actorName: widget.actorName,
        ),
        tabletScaffold: PronunciationScreenTablet(
          conversationId: widget.conversationId,
          dialogId: widget.dialogId,
          conversationEn: widget.conversationEn,
          conversationBn: widget.conversationBn,
          conversationAudioFile: widget.conversationAudioFile,
          seqNumber: widget.seqNumber,
          conversationDetails: widget.conversationDetails,
          discussionTopic: widget.discussionTopic,
          discusTitle: widget.discusTitle,
          actorName: widget.actorName,
        ),
        desktopScaffold: PronunciationScreenTablet(
          conversationId: widget.conversationId,
          dialogId: widget.dialogId,
          conversationEn: widget.conversationEn,
          conversationBn: widget.conversationBn,
          conversationAudioFile: widget.conversationAudioFile,
          seqNumber: widget.seqNumber,
          conversationDetails: widget.conversationDetails,
          discussionTopic: widget.discussionTopic,
          discusTitle: widget.discusTitle,
          actorName: widget.actorName,
        ),
      ),
    );
  }
}
