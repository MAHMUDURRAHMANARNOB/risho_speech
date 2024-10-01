import 'package:flutter/material.dart';
import 'package:risho_speech/models/speakingExamDataModel.dart';
import 'package:risho_speech/screens/tablet/PracticeListeningScreenTablet.dart';
import 'package:risho_speech/screens/tablet/SpeakingTestReportScreenTablet.dart';

import '../responsive/responsive_layout.dart';
import 'Mobile/PracticeListeningScreenMobile.dart';
import 'Mobile/SpeakingTestReportScreenMobile.dart';

class SpeakingTestReportScreen extends StatefulWidget {
  final Report report;

  const SpeakingTestReportScreen({super.key, required this.report});

  @override
  State<SpeakingTestReportScreen> createState() =>
      _SpeakingTestReportScreenState();
}

class _SpeakingTestReportScreenState extends State<SpeakingTestReportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileScaffold: SpeakingTestReportScreenMobile(
          report: widget.report,
        ),
        tabletScaffold: SpeakingTestReportScreenMobile(
          report: widget.report,
        ),
        desktopScaffold: SpeakingTestReportScreenMobile(
          report: widget.report,
        ),
      ),
    );
  }
}
