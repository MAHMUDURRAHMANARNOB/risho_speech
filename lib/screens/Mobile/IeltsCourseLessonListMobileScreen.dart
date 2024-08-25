import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:risho_speech/providers/ieltsCourseLessonListProvider.dart';
import 'package:risho_speech/screens/IeltsCourseBoard.dart';

import '../../providers/auth_provider.dart';
import '../../ui/colors.dart';

class IeltsCourseLessonListMobileScreen extends StatefulWidget {
  final int courseId;
  final String courseTitle;

  const IeltsCourseLessonListMobileScreen(
      {super.key, required this.courseId, required this.courseTitle});

  @override
  State<IeltsCourseLessonListMobileScreen> createState() =>
      _IeltsCourseLessonListMobileScreenState();
}

class _IeltsCourseLessonListMobileScreenState
    extends State<IeltsCourseLessonListMobileScreen> {
  IeltsCourseLessonListProvider ieltsCourseLessonListProvider =
      IeltsCourseLessonListProvider();

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<AuthProvider>(context, listen: false).user?.id;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Lessons",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Text(
                "Welcome to our ${widget.courseTitle} Course",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500),
              ),
              _lessonList(userId!, widget.courseId),
            ],
          ),
        ),
      ),
    );
  }

  Widget _lessonList(int userId, int courseId) {
    return FutureBuilder<void>(
      future: ieltsCourseLessonListProvider.fetchIeltsCourseLessonList(
          courseId, userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: SpinKitThreeInOut(
              color: AppColors.primaryColor,
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            itemCount: ieltsCourseLessonListProvider
                .ieltsCourseLessonListResponse!.videoList.length,
            itemBuilder: (context, index) {
              final category = ieltsCourseLessonListProvider
                  .ieltsCourseLessonListResponse!.videoList[index];
              return GestureDetector(
                onTap: () {
                  Fluttertoast.showToast(msg: category.lessonId.toString());
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => IeltsCourseBoard(
                        lessonId: category.lessonId,
                        lessonName: category.lessonTitle,
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 5.0),
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: AppColors.vocabularyCatCardColor,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Text(
                    category.lessonTitle,
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
