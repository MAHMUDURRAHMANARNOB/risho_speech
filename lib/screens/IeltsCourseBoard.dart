import 'package:flutter/material.dart';
import 'package:risho_speech/screens/tablet/IeltsCourseBoardTabletScreen.dart';

import '../responsive/responsive_layout.dart';
import 'Mobile/IeltsCourseBoardMobileScreen.dart';

class IeltsCourseBoard extends StatefulWidget {
  final int lessonId;
  final String lessonName;

  const IeltsCourseBoard(
      {super.key, required this.lessonId, required this.lessonName});

  @override
  State<IeltsCourseBoard> createState() => _IeltsCourseBoardState();
}

class _IeltsCourseBoardState extends State<IeltsCourseBoard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileScaffold: IeltsCourseBoardMobileScreen(
          lessonId: widget.lessonId,
          lessonName: widget.lessonName,
        ),
        tabletScaffold: IeltsCourseBoardMobileScreen(
          lessonId: widget.lessonId,
          lessonName: widget.lessonName,
        ),
        desktopScaffold: IeltsCourseBoardMobileScreen(
          lessonId: widget.lessonId,
          lessonName: widget.lessonName,
        ),
      ),
    );
  }
}
