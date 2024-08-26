import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconsax/iconsax.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Welcome to our ",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                    TextSpan(
                      text: widget.courseTitle,
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        // Set your desired color here
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: " Course",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Lessons: ",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
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
                  // Fluttertoast.showToast(msg: category.lessonId.toString());
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
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          category.lessonTitle,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      SizedBox(width: 5.0),
                      Icon(
                        IconsaxPlusBold.arrow_circle_right,
                        color: AppColors.primaryColor,
                        size: 34,
                      ),
                    ],
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
