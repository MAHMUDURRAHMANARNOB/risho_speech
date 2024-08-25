import 'package:flutter/material.dart';
import 'package:risho_speech/screens/tablet/IeltsCourseBoardTablet.dart';

import '../responsive/responsive_layout.dart';
import 'Mobile/IeltsCourseLessonListMobileScreen.dart';

class IeltsCourseLessonListScreen extends StatefulWidget {
  final int courseId;
  final String courseTitle;

  const IeltsCourseLessonListScreen(
      {super.key, required this.courseId, required this.courseTitle});

  @override
  State<IeltsCourseLessonListScreen> createState() =>
      _IeltsCourseLessonListScreenState();
}

class _IeltsCourseLessonListScreenState
    extends State<IeltsCourseLessonListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileScaffold: IeltsCourseLessonListMobileScreen(
          courseId: widget.courseId,
          courseTitle: widget.courseTitle,
        ),
        tabletScaffold: IeltsCourseLessonListMobileScreen(
          courseId: widget.courseId,
          courseTitle: widget.courseTitle,
        ),
        desktopScaffold: IeltsCourseLessonListTabletScreen(
          courseId: widget.courseId,
        ),
      ),
    );
  }
}
