import 'package:flutter/material.dart';
import 'package:risho_speech/screens/tablet/InstructionIeltsListeningScreenTablet.dart';

import '../responsive/responsive_layout.dart';
import 'Mobile/InstructionIeltsListeningScreenMobile.dart';

class InstructionIeltsListeningScreen extends StatefulWidget {
  const InstructionIeltsListeningScreen({super.key});

  @override
  State<InstructionIeltsListeningScreen> createState() =>
      _InstructionIeltsListeningScreenState();
}

class _InstructionIeltsListeningScreenState
    extends State<InstructionIeltsListeningScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileScaffold: InstructionIeltsListeningScreenMobile(),
        tabletScaffold: InstructionIeltsListeningScreenMobile(),
        desktopScaffold: InstructionIeltsListeningScreenMobile(),
      ),
    );
  }
}
