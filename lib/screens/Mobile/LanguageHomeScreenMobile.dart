import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:provider/provider.dart';
import 'package:risho_speech/screens/LanguageTutorScreen.dart';

import '../../models/LanguageTutorResponseDataModel.dart';
import '../../models/tutorSpokenCourseDataModel.dart';
import '../../providers/LanguageTutorResponseProvider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/languageListProvider.dart';
import '../../ui/colors.dart';

class LanguageHomeScreenMobile extends StatefulWidget {
  const LanguageHomeScreenMobile({super.key});

  @override
  State<LanguageHomeScreenMobile> createState() =>
      _LanguageHomeScreenMobileState();
}

class _LanguageHomeScreenMobileState extends State<LanguageHomeScreenMobile> {
  LanguageListProvider languageListProvider = LanguageListProvider();

  late int userId = Provider.of<AuthProvider>(context, listen: false).user!.id;
  late String userName =
      Provider.of<AuthProvider>(context, listen: false).user!.username;
  late String fullName =
      Provider.of<AuthProvider>(context, listen: false).user!.name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Language",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: [
              const Text(
                "Learn A New Language",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 34,
                ),
              ),
              _languageList()
            ],
          ),
        ),
      ),
    );
  }

  Widget _languageList() {
    return FutureBuilder<void>(
      future: languageListProvider.fetchLanguageList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
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
            physics: NeverScrollableScrollPhysics(),
            itemCount:
                languageListProvider.languageListResponse!.langList.length,
            itemBuilder: (context, index) {
              final category =
                  languageListProvider.languageListResponse!.langList[index];
              return GestureDetector(
                onTap: () async {
                  var languageTutorProvider =
                      Provider.of<LanguageTutorResponseProvider>(context,
                          listen: false);
                  String? courseId; // Initially null
                  File? audioFile;
                  // Show the loading dialog
                  showDialog(
                    context: context,
                    barrierDismissible:
                        false, // Prevent dismissing by tapping outside
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Container(
                          // width: double.maxFinite,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                "assets/images/risho_guru_icon.png",
                                width: 80,
                                height: 80,
                              ),
                              SizedBox(height: 5),
                              const SpinKitChasingDots(
                                color: AppColors.primaryColor,
                              ),
                            ],
                          ),
                        ), // Loading spinner
                      );
                    },
                  );

                  //Call the api
                  await languageTutorProvider.fetchLanguageTutorResponse(userId,
                      fullName, courseId, audioFile, "N", category.langName);

                  // Dismiss the dialog once loading is done
                  if (mounted && !languageListProvider.isLoading) {
                    Navigator.pop(context); // Close the dialog
                  }

                  //Handling the api response
                  if (mounted) {
                    if (languageTutorProvider.successResponse != null) {
                      // Navigate to next page if success
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LanguageTutorScreen(
                            tutorResponse:
                                languageTutorProvider.successResponse!,
                            languageName: category.langName,
                          ), // Your new page screen
                        ),
                      );
                    } else if (languageTutorProvider
                            .tutorNotSelectedResponse!.errorCode ==
                        210) {
                      // Show category dialog if response code is 210
                      _dialogBoxForCategory(
                        languageTutorProvider
                            .tutorNotSelectedResponse!.courseList,
                        category.langName,
                      );
                      print("something wrong 210");
                    } else {
                      print("error");
                    }
                  }
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 5.0),
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
                          IconsaxPlusBold.language_square,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      SizedBox(width: 5.0),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            category.langName,
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

  Future<Future<Object?>> _dialogBoxForCategory(
      List<LanguageCourse> courseList, String langName) async {
    final imageIcons = [
      "assets/images/level_icons/chicken.png",
      "assets/images/level_icons/elementary1.png",
      "assets/images/level_icons/intermediate-level.png",
      "assets/images/level_icons/upper intermediate-level.png",
      "assets/images/level_icons/professional.png",
      "assets/images/level_icons/support.png",
    ];
    return showGeneralDialog(
      context: context,
      barrierDismissible: false,
      transitionBuilder: (context, a1, a2, widget) {
        return Transform.scale(
          scale: a1.value,
          child: Opacity(
            opacity: a1.value,
            child: AlertDialog(
              title: const Text(
                'Choose your level',
                style: TextStyle(color: Colors.white),
              ),
              content: Container(
                width: double.maxFinite,
                child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () async {
                        await _handleCourseSelection(
                            context, index, courseList, langName);
                      },
                      child: Container(
                        margin: EdgeInsets.all(10.0),
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: /*color[index]*/
                              AppColors.backgroundColorDark,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          // mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  color: /*AppColors.primaryColor2*/
                                      /*color[index].withOpacity(0.2)*/
                                      Colors.white,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Image.asset(
                                  imageIcons[index],
                                  // color: /*AppColors.primaryColor*/ color[index],
                                  width: 34.0,
                                  height: 34.0,
                                  // size: 24.0,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                textAlign: TextAlign.center,
                                '${courseList[index].courseName}',
                                style: TextStyle(
                                  color: /*color[index]*/ Colors.white,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: AppColors.primaryColor.withOpacity(0.2)),
                  child: const Text(
                    'Close',
                    style: TextStyle(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return SizedBox(
          child: BackButton(
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  Future<void> _handleCourseSelection(BuildContext context, int index,
      List<LanguageCourse> courseList, String langName) async {
    var courseProvider =
        Provider.of<LanguageTutorResponseProvider>(context, listen: false);
    int? courseId = courseList[index].courseId;
    File? audioFile;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                "assets/images/risho_guru_icon.png",
                width: 50,
                height: 50,
              ),
              SpinKitChasingDots(
                color: AppColors.primaryColor,
              ),
            ],
          ),
        );
      },
    );
    // Call the API
    await courseProvider.fetchLanguageTutorResponse(
        userId, fullName, courseId.toString(), audioFile, "N", langName);

    print("tutor response: ${courseProvider.successResponse?.aiDialogue}");
    Navigator.pop(context);
    // Handle the API response
    if (courseProvider.successResponse != null) {
      // Navigate to TutorScreen on success
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LanguageTutorScreen(
            tutorResponse: courseProvider.successResponse!,
            languageName: langName,
          ),
        ),
      );
    } else if (courseProvider.tutorNotSelectedResponse?.errorCode == 210) {
      // Show category dialog if error code is 210
      /*_dialogBoxForCategory(
          courseProvider.tutorNotSelectedResponse!.courseList);*/
      print("response 210 in last _handleCourseSelection- language home");
    } else {
      print("Error occurred during API call");
    }
  }
}
