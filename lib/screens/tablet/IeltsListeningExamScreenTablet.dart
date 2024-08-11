import 'package:flutter/material.dart';

class IeltsListeningExamScreenTablet extends StatefulWidget {
  final String audioFile, question;
  final int examId;

  const IeltsListeningExamScreenTablet(
      {super.key,
      required this.audioFile,
      required this.question,
      required this.examId});

  @override
  State<IeltsListeningExamScreenTablet> createState() =>
      _IeltsListeningExamScreenTabletState();
}

class _IeltsListeningExamScreenTabletState
    extends State<IeltsListeningExamScreenTablet> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
