import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:risho_speech/screens/ChatScreen.dart';
import 'package:risho_speech/ui/colors.dart';

import '../../providers/spokenLessonListProvider.dart';

class PracticeGuidedScreenMobile extends StatefulWidget {
  const PracticeGuidedScreenMobile({super.key});

  @override
  State<PracticeGuidedScreenMobile> createState() =>
      _PracticeGuidedScreenMobileState();
}

class _PracticeGuidedScreenMobileState
    extends State<PracticeGuidedScreenMobile> {
  final SpokenLessonListProvider spokenLessonListProvider =
      SpokenLessonListProvider();

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
        body: FutureBuilder<void>(
          future: spokenLessonListProvider.fetchSpokenLessonListResponse(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: const SpinKitThreeInOut(
                  color: AppColors.primaryColor,
                ),
              );
            } else if (snapshot.hasError) {
              // Handle error
              return Center(
                child: Text("No Data Found"),
              );
            } else {
              return ListView.builder(
                  itemCount: spokenLessonListProvider
                      .spokenLessonListResponse!.lessons.length,
                  itemBuilder: (context, index) {
                    final lesson = spokenLessonListProvider
                        .spokenLessonListResponse!.lessons[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                    id: lesson.id.toString(),
                                  )),
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
                            lesson.conversationName, // Display conversationName
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                  });
            }
          },
        ));
  }
}
