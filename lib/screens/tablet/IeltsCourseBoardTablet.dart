import 'package:flutter/material.dart';

class IeltsCourseLessonListTabletScreen extends StatefulWidget {
  final int courseId;

  const IeltsCourseLessonListTabletScreen({super.key, required this.courseId});

  @override
  State<IeltsCourseLessonListTabletScreen> createState() =>
      _IeltsCourseLessonListTabletScreenState();
}

class _IeltsCourseLessonListTabletScreenState
    extends State<IeltsCourseLessonListTabletScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Course"),
      ),
      body: Center(
        child: Text(widget.courseId.toString()),
      ),
    );
  }
}
