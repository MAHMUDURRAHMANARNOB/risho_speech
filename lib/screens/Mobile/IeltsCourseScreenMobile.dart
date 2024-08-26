import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconsax/iconsax.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:risho_speech/utils/constants/colors.dart';

import '../../models/ieltsCourseListDataModel.dart';
import '../../providers/IeltsCourseListProvider.dart';
import '../../ui/colors.dart';
import '../IeltsCourseLessonListScreen.dart';

class IeltsCourseScreenMobile extends StatefulWidget {
  const IeltsCourseScreenMobile({super.key});

  @override
  State<IeltsCourseScreenMobile> createState() =>
      _IeltsCourseScreenMobileState();
}

class _IeltsCourseScreenMobileState extends State<IeltsCourseScreenMobile> {
  IeltsCourseListProvider ieltsCourseListProvider = IeltsCourseListProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "All Courses",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: _cardList(),
    );
  }

  Widget _cardList() {
    return FutureBuilder<void>(
      future: ieltsCourseListProvider.fetchIeltsCourseList(),
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
            itemCount: ieltsCourseListProvider
                .ieltsCourseListResponse!.videoList.length,
            itemBuilder: (context, index) {
              final category = ieltsCourseListProvider
                  .ieltsCourseListResponse!.videoList[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => IeltsCourseLessonListScreen(
                        courseId: category.courseId,
                        courseTitle: category.courseTitle,
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.all(8.0),
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: AppColors.vocabularyCatCardColor,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor2.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          IconsaxPlusLinear.book,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      SizedBox(width: 5.0),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            category.courseTitle,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
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
