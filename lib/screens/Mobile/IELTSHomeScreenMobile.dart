import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iconsax/iconsax.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:provider/provider.dart';
import 'package:risho_speech/screens/IeltsCoursesScreen.dart';
import 'package:risho_speech/screens/IeltsVocabularyCategoryListScreen.dart';
import 'package:risho_speech/screens/InstructionIeltsListeningScreen.dart';
import 'package:risho_speech/ui/colors.dart';

import '../../models/IeltsCoursesDataModel.dart';
import '../../models/ieltsCourseListDataModel.dart';
import '../../providers/IeltsCourseListProvider.dart';
import '../IeltsAssistantScreen.dart';
import '../IeltsCourseLessonListScreen.dart';
import '../InstructionIeltsSpeakingScreen.dart';

class IELTSHomeScreenMobile extends StatefulWidget {
  const IELTSHomeScreenMobile({super.key});

  @override
  State<IELTSHomeScreenMobile> createState() => _IELTSHomeScreenMobileState();
}

class _IELTSHomeScreenMobileState extends State<IELTSHomeScreenMobile> {
  IeltsCourseListProvider ieltsCourseListProvider = IeltsCourseListProvider();

  bool _showBackButton = false;

  @override
  void didUpdateWidget(IELTSHomeScreenMobile oldWidget) {
    super.didUpdateWidget(oldWidget);
    _showBackButton = Navigator.of(context).canPop();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'IELTS',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: const TextSpan(
                    text: 'Start your ',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                    children: <TextSpan>[
                      TextSpan(
                          text: 'IELTS',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.redAccent)),
                      TextSpan(
                          text: ' Preparation journey with',
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 20,
                              color: Colors.white)),
                      TextSpan(
                          text: ' Risho',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: AppColors.primaryColor)),
                    ],
                  ),
                ),
                /*RichText(text: "Start your"),
                Text(
                  "Start your IELTS Preparation journey with Risho",
                  style: TextStyle(fontSize: 20),
                ),*/
                const SizedBox(height: 10),
                /*IELTS BUTTONS*/
                Container(
                  child: Row(
                    children: [
                      /*Skills*/
                      Expanded(
                        flex: 1,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(40.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const InstructionIeltsListeningScreen()),
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.all(5.0),
                              // width: 200,
                              height: 130,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24.0),
                                gradient: const LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  colors: [
                                    Color.fromRGBO(222, 253, 136, 1),
                                    Color.fromRGBO(8, 119, 75, 1)
                                  ],
                                ),
                              ),
                              child: Stack(
                                children: [
                                  const Positioned(
                                    top: 50.0,
                                    left: 10.0,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Practice',
                                          style: TextStyle(
                                            fontSize: 22.0,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          'Listening',
                                          style: TextStyle(
                                            fontSize: 22.0,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Golf Flag image
                                  Positioned(
                                    bottom: 95.0,
                                    right: -50.0,
                                    child: Transform(
                                      transform: Matrix4.rotationZ(0.785),
                                      // Rotates 45 degrees (pi/4 radians)
                                      child: Container(
                                        height: 75.0,
                                        width: 70.0,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              // Shadow color with transparency
                                              offset: Offset(4.0, 6.0),
                                              // Shadow offset in x and y direction

                                              blurRadius:
                                                  5.0, // Shadow blur radius
                                            ),
                                          ],
                                        ),
                                        child: null,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 90.0,
                                    right: 8.0,
                                    child: Image.asset(
                                        'assets/images/golf_flag.png',
                                        height: 40.0,
                                        width: 40.0),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      /*Topics*/
                      Expanded(
                        flex: 1,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(40.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const InstructionIeltsSpeakingScreen()),
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.all(5.0),
                              // width: 200,
                              height: 130,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24.0),
                                gradient: const LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  colors: [
                                    Color.fromRGBO(253, 140, 0, 1),
                                    Color.fromRGBO(248, 54, 1, 1)
                                  ],
                                ),
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    top: 50.0,
                                    left: 10.0,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Practice',
                                          style: TextStyle(
                                            fontSize: 22.0,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          'Speaking',
                                          style: TextStyle(
                                            fontSize: 22.0,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Diamond image
                                  Positioned(
                                    bottom: 95.0,
                                    right: -50.0,
                                    child: Transform(
                                      transform: Matrix4.rotationZ(0.785),
                                      // Rotates 45 degrees (pi/4 radians)
                                      child: Container(
                                        height: 75.0,
                                        width: 70.0,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.blueGrey
                                                  .withOpacity(0.5),
                                              // Shadow color with transparency
                                              offset: Offset(4.0, 6.0),
                                              // Shadow offset in x and y direction

                                              blurRadius:
                                                  5.0, // Shadow blur radius
                                            ),
                                          ],
                                        ),
                                        child: null,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 90.0,
                                    right: 8.0,
                                    child: Image.asset(
                                        'assets/images/ielts_badge.png',
                                        height: 35.0,
                                        width: 40.0),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),

                /*VOCABULARY*/
                const Text(
                  "Vocabulary",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                SizedBox(height: 10),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /*IELTS Vocabulary*/
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            _dialogBoxForCategory("N");
                          },
                          child: vocabularyContainers(
                            title: "IELTS&Vocabulary",
                            gradientColors: [
                              Color.fromRGBO(254, 83, 83, 1),
                              Color.fromRGBO(168, 2, 0, 1),
                            ],
                          ),
                        ),
                      ),
                      /*Phrase And Idioms*/
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            _dialogBoxForCategory("Y");
                          },
                          child: vocabularyContainers(
                            title: "Phrase&Idioms",
                            gradientColors: [
                              Color.fromRGBO(160, 214, 120, 1),
                              Color.fromRGBO(50, 144, 88, 1),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                /*COURSES*/
                const SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Courses",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    Column(
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const IeltsCourseScreen()),
                            );
                          },
                          child: Row(
                            children: [
                              const Text(
                                "View all",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  // decoration: TextDecoration.underline,
                                ),
                              ),
                              Image.asset(
                                "assets/images/right_arrow.gif",
                                width: 30,
                                height: 50,
                                color: AppColors.primaryColor,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                // const SizedBox(height: 5.0),
                _cardList(),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => IeltsAssistantScreen(),
              ),
            );
          },
          /*foregroundColor: customizations[index].$1,
          backgroundColor: customizations[index].$2,
          shape: customizations[index].$3,*/
          // mini: true,

          backgroundColor: AppColors.secondaryCardColor,
          label: Row(
            children: [
              Text(
                "Ask me",
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(width: 5),
              Image.asset("assets/images/bot.gif", width: 30, height: 30),
            ],
          ),
          // child: Image.asset("assets/images/bot.gif", width: 30, height: 30),
        ),
      ),
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
          return Container(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemCount: 4,
              itemBuilder: (context, index) {
                final category = ieltsCourseListProvider
                    .ieltsCourseListResponse!.videoList[index];
                return Container(
                  width: 200, // Adjust width as needed
                  margin: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundColorDark,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        child: Image.asset(
                          "assets/images/background_contents/colorful-abstract-sculpture.png",
                          fit: BoxFit.fill,
                        ),
                      ),
                      Positioned(
                        child: BackdropFilter(
                          // blendMode: BlendMode.exclusion,
                          filter: ImageFilter.blur(
                            sigmaX: 20,
                            sigmaY: 20,
                          ),
                          child: SizedBox(),
                        ),
                      ),
                      Column(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                category.courseTitle,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      IeltsCourseLessonListScreen(
                                    courseId: category.courseId,
                                    courseTitle: category.courseTitle,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(10.0),
                              decoration: const BoxDecoration(
                                  color: AppColors.primaryColor2,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(12.0),
                                    bottomRight: Radius.circular(12.0),
                                  )),
                              child: const Text(
                                "Start Now",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }

  Future<Future<Object?>> _dialogBoxForCategory(isIdioms) async {
    final title = ["Listening", "Speaking", "Reading", "Writing"];
    final color = [
      Colors.teal,
      Colors.redAccent,
      Colors.lightBlueAccent,
      Colors.orangeAccent
    ];
    final icons = [
      IconsaxPlusBold.headphone,
      IconsaxPlusBold.microphone,
      IconsaxPlusBold.book,
      IconsaxPlusBold.pen_tool
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
                'Choose a Category',
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
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                IeltsVocabularyCategoryListScreen(
                              topicCategory: index + 1,
                              isIdioms: isIdioms,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.all(10.0),
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: /*color[index]*/ AppColors.backgroundColorDark,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: /*AppColors.primaryColor2*/
                                    color[index].withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Icon(
                                icons[index],
                                color: /*AppColors.primaryColor*/ color[index],
                                size: 24.0,
                              ),
                            ),
                            Text(
                              '${title[index]}',
                              style: TextStyle(
                                color: /*color[index]*/ Colors.white,
                                fontWeight: FontWeight.bold,
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
}

class vocabularyContainers extends StatelessWidget {
  final String title;
  final List<Color> gradientColors;

  vocabularyContainers({
    required this.title,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.split('&').first.trim(),
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          Text(
            title.split('&').last.trim(),
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}
