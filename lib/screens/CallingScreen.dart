import 'package:flutter/material.dart';
import 'package:risho_speech/screens/tablet/CallingScreenTablet.dart';

import '../responsive/responsive_layout.dart';
import 'Mobile/CallingScreenMobile.dart';

class CallingScreen extends StatefulWidget {
  final int agentId;
  final String agentName;
  final String agentGander;
  final String? agentImage;
  final String sessionId;
  final String firstText;
  final String firstTextBn;
  final String agentAudio;

  CallingScreen({
    super.key,
    required this.agentId,
    required this.sessionId,
    required this.agentName,
    this.agentImage,
    required this.agentAudio,
    required this.firstText,
    required this.firstTextBn,
    required this.agentGander,
  });

  @override
  State<CallingScreen> createState() => _CallingScreenState();
}

class _CallingScreenState extends State<CallingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileScaffold: CallingScreenMobile(
          agentId: widget.agentId,
          sessionId: widget.sessionId,
          agentName: widget.agentName,
          agentImage: widget.agentImage,
          agentAudio: widget.agentAudio,
          firstText: widget.firstText,
          firstTextBn: widget.firstTextBn,
          agentGander: widget.agentGander,
        ),
        tabletScaffold: CallingScreenTablet(
          agentId: widget.agentId,
          sessionId: widget.sessionId,
          agentName: widget.agentName,
          agentImage: widget.agentImage,
          agentAudio: widget.agentAudio,
          firstText: widget.firstText,
          firstTextBn: widget.firstTextBn,
          agentGander: widget.agentGander,
        ),
        desktopScaffold: CallingScreenTablet(
          agentId: widget.agentId,
          sessionId: widget.sessionId,
          agentName: widget.agentName,
          agentImage: widget.agentImage,
          agentAudio: widget.agentAudio,
          firstText: widget.firstText,
          firstTextBn: widget.firstTextBn,
          agentGander: widget.agentGander,
        ),
      ),
    );
  }
}
