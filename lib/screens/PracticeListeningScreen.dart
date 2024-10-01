import 'package:flutter/material.dart';
import 'package:risho_speech/screens/tablet/PracticeListeningScreenTablet.dart';

import '../responsive/responsive_layout.dart';
import 'Mobile/PracticeListeningScreenMobile.dart';

class PracticeListeningScreen extends StatefulWidget {
  const PracticeListeningScreen({super.key});

  @override
  State<PracticeListeningScreen> createState() =>
      _PracticeListeningScreenState();
}

class _PracticeListeningScreenState extends State<PracticeListeningScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileScaffold: PracticeListeningScreenMobile(),
        tabletScaffold: PracticeListeningScreenMobile(),
        desktopScaffold: PracticeListeningScreenMobile(),
      ),
    );
  }
}
