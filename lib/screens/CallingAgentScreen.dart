import 'package:flutter/material.dart';
import 'package:risho_speech/screens/tablet/CallingAgentScreenTablet.dart';

import '../responsive/responsive_layout.dart';
import 'Mobile/CallingAgentScreenMobile.dart';

class CallingAgentScreen extends StatefulWidget {
  CallingAgentScreen({super.key});

  @override
  State<CallingAgentScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<CallingAgentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileScaffold: CallingAgentScreenMobile(),
        tabletScaffold: CallingAgentScreenMobile(),
        desktopScaffold: CallingAgentScreenMobile(),
      ),
    );
  }
}
