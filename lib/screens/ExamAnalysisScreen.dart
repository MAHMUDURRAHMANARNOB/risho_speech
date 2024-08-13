import 'package:flutter/material.dart';
import 'package:risho_speech/screens/tablet/ExamAnalysisScreenTablet.dart';

import '../responsive/responsive_layout.dart';
import 'Mobile/ExamAnalysisScreenMobile.dart';

class ExamAnalysisScreen extends StatefulWidget {
  const ExamAnalysisScreen({super.key});

  @override
  State<ExamAnalysisScreen> createState() => _ExamAnalysisScreenState();
}

class _ExamAnalysisScreenState extends State<ExamAnalysisScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileScaffold: ExamAnalysisScreenMobile(),
        tabletScaffold: ExamAnalysisScreenMobile(),
        desktopScaffold: ExamAnalysisScreenTablet(),
      ),
    );
  }
}
