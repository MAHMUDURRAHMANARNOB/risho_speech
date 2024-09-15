import 'package:flutter/material.dart';

import '../../models/TutorResponseDataModel.dart';

class TutorScreenMobile extends StatefulWidget {
  final TutorSuccessResponse tutorResponse;
  const TutorScreenMobile({super.key, required this.tutorResponse});

  @override
  State<TutorScreenMobile> createState() => _TutorScreenMobileState();
}

class _TutorScreenMobileState extends State<TutorScreenMobile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Learn with Tutor",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Text(widget.tutorResponse.lessonTitle),
            Text(widget.tutorResponse.chapterTitle),
            Text(widget.tutorResponse.aiDialogue),
          ],
        ),
      ),
    );
  }
}
