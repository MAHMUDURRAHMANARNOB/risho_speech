import 'package:flutter/material.dart';
import 'package:risho_speech/screens/tablet/PracticeGuidedScreenTablet.dart';

import '../responsive/responsive_layout.dart';
import 'Mobile/PracticeGuidedScreenMobile.dart';

class PracticeGuidedScreen extends StatefulWidget {
  final String? screenName;

  const PracticeGuidedScreen({super.key, required this.screenName});

  @override
  State<PracticeGuidedScreen> createState() => _PracticeGuidedScreenState();
}

class _PracticeGuidedScreenState extends State<PracticeGuidedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileScaffold: PracticeGuidedScreenMobile(
          screenName: widget.screenName!,
        ),
        tabletScaffold: PracticeGuidedScreenTablet(
          screenName: widget.screenName!,
        ),
        desktopScaffold: PracticeGuidedScreenTablet(
          screenName: widget.screenName!,
        ),
      ),
    );
  }
}
