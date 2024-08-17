import 'package:flutter/material.dart';
import 'package:risho_speech/screens/tablet/InstructionIeltsSpeakingScreenTablet.dart';

import '../responsive/responsive_layout.dart';
import 'Mobile/InstructionIeltsSpeakingScreenMobile.dart';

class InstructionIeltsSpeakingScreen extends StatefulWidget {
  const InstructionIeltsSpeakingScreen({super.key});

  @override
  State<InstructionIeltsSpeakingScreen> createState() =>
      _InstructionIeltsSpeakingScreenState();
}

class _InstructionIeltsSpeakingScreenState
    extends State<InstructionIeltsSpeakingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileScaffold: InstructionIeltsSpeakingScreenMobile(),
        tabletScaffold: InstructionIeltsSpeakingScreenMobile(),
        desktopScaffold: InstructionIeltsSpeakingScreenTablet(),
      ),
    );
  }
}
