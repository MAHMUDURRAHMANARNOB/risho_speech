import 'package:flutter/material.dart';
import 'package:risho_speech/screens/ChatScreen.dart';
import 'package:risho_speech/ui/colors.dart';

class PracticeGuidedScreenMobile extends StatefulWidget {
  const PracticeGuidedScreenMobile({super.key});

  @override
  State<PracticeGuidedScreenMobile> createState() =>
      _PracticeGuidedScreenMobileState();
}

class _PracticeGuidedScreenMobileState
    extends State<PracticeGuidedScreenMobile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Practice Guided Lesson",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatScreen()),
              );
            },
            child: Container(
              margin: EdgeInsets.all(10.0),
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: AppColors.ExpandedCourseCardColor,
              ),
              child: Center(
                child: Text(
                  "Basic Conversation Practice",
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
