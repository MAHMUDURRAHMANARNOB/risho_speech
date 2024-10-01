import 'package:flutter/material.dart';
import 'package:risho_speech/screens/tablet/ExamAnalysisScreenTablet.dart';

import '../models/listeningPracticeBandScoreDataModel.dart';
import '../responsive/responsive_layout.dart';
import 'Mobile/ExamAnalysisScreenMobile.dart';

class ExamAnalysisScreen extends StatefulWidget {
  final Map<String, dynamic> listeningData;

  const ExamAnalysisScreen({super.key, required this.listeningData});

  @override
  State<ExamAnalysisScreen> createState() => _ExamAnalysisScreenState();
}

class _ExamAnalysisScreenState extends State<ExamAnalysisScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileScaffold: ExamAnalysisScreenMobile(
          listeningData: widget.listeningData,
        ),
        tabletScaffold: ExamAnalysisScreenMobile(
          listeningData: widget.listeningData,
        ),
        desktopScaffold: ExamAnalysisScreenMobile(
          listeningData: widget.listeningData,
        ),
      ),
    );
  }
}
