import 'package:flutter/material.dart';
import 'package:risho_speech/screens/tablet/CallingScreenTablet.dart';

import '../responsive/responsive_layout.dart';
import 'Mobile/CallingScreenMobile.dart';

class CallingScreen extends StatefulWidget {
  final String agentId;
  final String sessionId;
  CallingScreen({super.key, required this.agentId, required this.sessionId});

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
        ),
        tabletScaffold: CallingScreenTablet(),
        desktopScaffold: CallingScreenTablet(),
      ),
    );
  }
}
