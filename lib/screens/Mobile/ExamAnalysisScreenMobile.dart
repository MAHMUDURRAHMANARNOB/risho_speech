import 'package:flutter/material.dart';

class ExamAnalysisScreenMobile extends StatefulWidget {
  const ExamAnalysisScreenMobile({super.key});

  @override
  State<ExamAnalysisScreenMobile> createState() =>
      _ExamAnalysisScreenMobileState();
}

class _ExamAnalysisScreenMobileState extends State<ExamAnalysisScreenMobile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Congrats"),
      ),
    );
  }
}
