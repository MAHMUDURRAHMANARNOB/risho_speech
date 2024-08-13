import 'package:flutter/material.dart';
import 'package:risho_speech/screens/tablet/IeltsListeningExamScreenTablet.dart';

import '../responsive/responsive_layout.dart';
import 'Mobile/IeltsListeningExamScreenMobile.dart';

class IeltsListeningExamScreen extends StatefulWidget {
  /*final String audioFile, question;
  final int examId;*/

  const IeltsListeningExamScreen({
    super.key,
    /*required this.audioFile,
      required this.question,
      required this.examId*/
  });

  @override
  State<IeltsListeningExamScreen> createState() =>
      _IeltsListeningExamScreenState();
}

class _IeltsListeningExamScreenState extends State<IeltsListeningExamScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileScaffold: IeltsListeningExamScreenMobile(
            /*audioFile: widget.audioFile,
            question: widget.question,
            examId: widget.examId*/
            ),
        tabletScaffold: IeltsListeningExamScreenMobile(
            /*audioFile: widget.audioFile,
            question: widget.question,
            examId: widget.examId*/
            ),
        desktopScaffold: IeltsListeningExamScreenTablet(
            /*audioFile: widget.audioFile,
            question: widget.question,
            examId: widget.examId*/
            ),
      ),
    );
  }
}
