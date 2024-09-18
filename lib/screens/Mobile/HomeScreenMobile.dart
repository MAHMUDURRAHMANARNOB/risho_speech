import 'dart:io';
import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iconsax/iconsax.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';
import 'package:risho_speech/models/TutorResponseDataModel.dart';
import 'package:risho_speech/screens/CallingAgentScreen.dart';
import 'package:risho_speech/screens/IeltsAssistantScreen.dart';
import 'package:risho_speech/screens/Mobile/IELTSHomeScreenMobile.dart';
import 'package:risho_speech/screens/PracticeGuidedScreen.dart';
import 'package:risho_speech/screens/TutorScreen.dart';
import 'package:risho_speech/screens/VocabularyCategoryScreen.dart';
import 'package:risho_speech/ui/colors.dart';
import 'package:risho_speech/utils/constants/colors.dart';

import '../../providers/TutorResponseProvider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/subscriptionStatus_provider.dart';
import '../IELTSHomeScreen.dart';
import '../packages_screen.dart';

class HomeScreenMobile extends StatefulWidget {
  const HomeScreenMobile({super.key});

  @override
  State<HomeScreenMobile> createState() => _HomeScreenMobileState();
}

class _HomeScreenMobileState extends State<HomeScreenMobile> {
  Widget ReuseableCard(String imagePath, String title, String subTitle) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(10),
      child: SizedBox(
        height: 200,
        width: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              imagePath,
              height: 100,
              fit: BoxFit.fitHeight,
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    subTitle,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    /*final userId = Provider.of<AuthProvider>(context, listen: false).user?.id;
    if (userId != null) {
      Provider.of<SubscriptionStatusProvider>(context, listen: false)
          .fetchSubscriptionData(userId);
    }*/
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = Provider.of<AuthProvider>(context, listen: false).user?.id;
      if (userId != null) {
        Provider.of<SubscriptionStatusProvider>(context, listen: false)
            .fetchSubscriptionData(userId);
      }
    });
  }

  final SubscriptionStatusProvider subscriptionStatusProvider =
      SubscriptionStatusProvider();
  late int userId = Provider.of<AuthProvider>(context).user!.id;
  late String userName = Provider.of<AuthProvider>(context).user!.username;
  late String fullName = Provider.of<AuthProvider>(context).user!.name;

  // late final userId;
  Future<void> _refresh() async {
    await subscriptionStatusProvider.fetchSubscriptionData(userId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // final userId = Provider.of<AuthProvider>(context).user?.id;
    // subscriptionStatusProvider.fetchSubscriptionData(userId!);
    final authProvider = Provider.of<AuthProvider>(context);
    userId = Provider.of<AuthProvider>(context).user!.id;
    userName = Provider.of<AuthProvider>(context).user!.username;
    fullName = Provider.of<AuthProvider>(context).user!.name;
    subscriptionStatusProvider.fetchSubscriptionData(userId);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SubscriptionStatusProvider>().fetchSubscriptionData(userId);
    });

    return SafeArea(
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: _refresh,
          // showChildOpacityTransition: false,
          // springAnimationDurationInMilliseconds: 1000,
          color: AppColors.secondaryCardColor,
          backgroundColor: AppColors.primaryColor,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /*TOP Greetings*/
                  Row(
                    children: [
                      Image.asset(
                        "assets/images/risho_guru_icon.png",
                        width: 50,
                        height: 40,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Hello",
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            fullName ?? 'UserName',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Audio Remaining
                  Container(
                    margin: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.backgroundColorDark,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Consumer<SubscriptionStatusProvider>(
                          builder: (context, provider, child) {
                            if (provider.isFetching) {
                              return const SpinKitThreeInOut(
                                size: 10.0,
                                color: AppColors.primaryColor,
                              ); // Show a loading indicator while fetching data for the first time
                            } else if (provider.subscriptionStatus == null) {
                              return const Text('No data available');
                            } else {
                              final audioRemains = provider
                                      .subscriptionStatus?.audioReamins
                                      ?.toString() ??
                                  '---';
                              return Container(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      audioRemains,
                                      style: const TextStyle(
                                          color: AppColors.primaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24),
                                    ),
                                    const Text(
                                      "Minutes Remaining",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 5.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const PackagesScreen()),
                              );
                            },
                            child: const Text(
                              "Add Minutes",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 3.0),

                  /*Tutor*/
                  GestureDetector(
                    onTap: () async {
                      var courseProvider = Provider.of<TutorResponseProvider>(
                          context,
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
                      await courseProvider.fetchEnglishTutorResponse(
                          userId, fullName, courseId, audioFile, "N");

                      // Dismiss the dialog once loading is done
                      if (mounted && !courseProvider.isLoading) {
                        Navigator.pop(context); // Close the dialog
                      }

                      //Handling the api response
                      if (mounted) {
                        if (courseProvider.successResponse != null) {
                          // Navigate to next page if success
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TutorScreen(
                                tutorResponse: courseProvider.successResponse!,
                              ), // Your new page screen
                            ),
                          );
                        } else if (courseProvider
                                .tutorNotSelectedResponse!.errorCode ==
                            210) {
                          // Show category dialog if response code is 210
                          _dialogBoxForCategory(courseProvider
                              .tutorNotSelectedResponse!.courseList);
                        } else {
                          print("error");
                        }
                      }
                    },
                    child: ThreeDCard(),
                  ),
                  const SizedBox(height: 5.0),
                  /*IELTS*/
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        double audioRemains =
                            Provider.of<SubscriptionStatusProvider>(context,
                                    listen: false)
                                .audioRemains;
                        if (audioRemains > 0.0) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => IELTSHomeScreen()),
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Minute expired'),
                              content: const Text(
                                  'You have no audio minutes remaining. Please purchase more.'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text(
                                    'OK',
                                    style: TextStyle(
                                        color: AppColors.secondaryColor),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const PackagesScreen()),
                                  ),
                                  child: const Text(
                                    'Purchase',
                                    style: TextStyle(
                                        color: AppColors.primaryColor),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                      child: Card(
                        color: Colors.red,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            // Adjust as needed
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Colors.transparent,
                                // Start with a transparent color
                                Colors.redAccent.withOpacity(0.3),
                                // Adjust opacity as needed
                              ],
                            ),
                          ),
                          child: Row(
                            children: [
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        "IELTS Preparation" /*"Start Speaking"*/,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        "Get ready for your IELTS exam with RISHO" /*"Practice speaking on real life scenarios with AI "*/,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Image.asset(
                                  "assets/images/ielts/ielts_icon.png" /*"assets/images/card_images/practice_guided.png"*/,
                                  fit: BoxFit.contain,
                                  height: 120,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 3.0),

                  /*PRACTICE DAILY LESSON & SPEECH TRAINER*/
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        /*Practice Daily lesson*/
                        Expanded(
                          child: OptionCards(
                            title: "Advance Speaking",
                            subTitle:
                                "Practice speaking on real life scenarios ",
                            imageUrl:
                                "assets/images/card_images/practice_guided.png",
                            bgColor: AppColors.primaryColor,
                            opacityColor: Colors.lightGreenAccent,
                            onPressed: () {
                              // double audioRemains = subscriptionStatusProvider.audioRemains;
                              double audioRemains =
                                  Provider.of<SubscriptionStatusProvider>(
                                          context,
                                          listen: false)
                                      .audioRemains;
                              // debugPrint(audioRemains.toString());
                              if (audioRemains > 0.0) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          PracticeGuidedScreen(
                                            screenName: 'PDL',
                                          )),
                                );
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Minute expired'),
                                    content: const Text(
                                        'You have no audio minutes remaining. Please purchase more.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: const Text(
                                          'OK',
                                          style: TextStyle(
                                              color: AppColors.secondaryColor),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const PackagesScreen()),
                                        ),
                                        child: const Text(
                                          'Purchase',
                                          style: TextStyle(
                                              color: AppColors.primaryColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                        // const SizedBox(height: 3.0),

                        /*IMPROVE PRONUNCIATION / Speech Trainer*/
                        Expanded(
                          child: OptionCards(
                            title: "Speech \nTrainer",
                            subTitle: "Learn how to pronounce sentences.",
                            imageUrl:
                                "assets/images/card_images/improve_speaking.png",
                            bgColor: AppColors.orange,
                            opacityColor: Colors.yellowAccent,
                            onPressed: () {
                              double audioRemains =
                                  Provider.of<SubscriptionStatusProvider>(
                                          context,
                                          listen: false)
                                      .audioRemains;
                              if (audioRemains > 0.0) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const PracticeGuidedScreen(
                                            screenName: 'IP',
                                          )),
                                );
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Minute expired'),
                                    content: const Text(
                                        'You have no audio minutes remaining. Please purchase more.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: const Text(
                                          'OK',
                                          style: TextStyle(
                                              color: AppColors.secondaryColor),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const PackagesScreen()),
                                        ),
                                        child: const Text(
                                          'Purchase',
                                          style: TextStyle(
                                              color: AppColors.primaryColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 3.0),

                  /*Vocabulary + Calling Section*/
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.all(0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          VocabularyCategoryScreen()),
                                );
                              },
                              child: Card(
                                color: AppColors.backgroundColorDark,
                                child: Container(
                                  padding: EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomLeft,
                                      colors: [
                                        Colors.transparent,
                                        // Start with a transparent color
                                        Colors.cyan.withOpacity(0.5),
                                        // Adjust opacity as needed
                                      ],
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: const Text(
                                              "Practice \nVocabulary",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(10.0),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color:
                                                  Colors.cyan.withOpacity(0.3),
                                            ),
                                            child: const Icon(
                                              IconsaxPlusBold.book,
                                              color: Colors.lightBlueAccent,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10.0),
                                      const Text(
                                        "Interactive Vocabulary Training",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        /*Call*/
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.all(0),
                            child: GestureDetector(
                              onTap: () {
                                double audioRemains =
                                    Provider.of<SubscriptionStatusProvider>(
                                            context,
                                            listen: false)
                                        .audioRemains;
                                if (audioRemains > 0.0) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CallingAgentScreen()),
                                  );
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Minute expired'),
                                      content: const Text(
                                          'You have no audio minutes remaining. Please purchase more.'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                          child: const Text(
                                            'OK',
                                            style: TextStyle(
                                                color:
                                                    AppColors.secondaryColor),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const PackagesScreen()),
                                          ),
                                          child: const Text(
                                            'Purchase',
                                            style: TextStyle(
                                                color: AppColors.primaryColor),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              },
                              child: Card(
                                color: AppColors.backgroundColorDark,
                                child: Container(
                                  padding: EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomLeft,
                                      colors: [
                                        Colors.transparent,
                                        // Start with a transparent color
                                        Colors.purple.withOpacity(1),
                                        // Adjust opacity as needed
                                      ],
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Expanded(
                                            child: Text(
                                              "Practice\nConversation",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Container(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.purpleAccent
                                                    .withOpacity(0.3),
                                              ),
                                              child: /*Icon(
                                              IconsaxPlusBold.call,
                                              color: Colors.purpleAccent,
                                            ),*/
                                                  Image.asset(
                                                "assets/images/card_images/practice_conv.gif",
                                                width: 24,
                                                height: 24,
                                                color: Colors.purpleAccent,
                                              )),
                                        ],
                                      ),
                                      const SizedBox(height: 10.0),
                                      const Text(
                                        "Speak more to improve your fluency",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<Future<Object?>> _dialogBoxForCategory(List<Course> courseList) async {
    final color = [
      Colors.teal,
      Colors.redAccent,
      Colors.lightBlueAccent,
      Colors.orangeAccent,
      Colors.purpleAccent,
      Colors.greenAccent
    ];
    final icons = [
      IconsaxPlusBold.bezier,
      IconsaxPlusBold.microphone,
      IconsaxPlusBold.book,
      IconsaxPlusBold.pen_tool,
      IconsaxPlusBold.pen_tool,
      IconsaxPlusBold.pen_tool,
    ];
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
                            context, index, courseList);
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
                            Expanded(
                              child: Text(
                                textAlign: TextAlign.center,
                                '${courseList[index].courseName}',
                                style: TextStyle(
                                  color: /*color[index]*/ Colors.white,
                                  fontWeight: FontWeight.bold,
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

  Future<void> _handleCourseSelection(
      BuildContext context, int index, List<Course> courseList) async {
    var courseProvider =
        Provider.of<TutorResponseProvider>(context, listen: false);
    int? courseId = courseList[index].courseId;
    File? audioFile;

    // Optionally, show a loading spinner (commented out to avoid showing multiple dialogs)
    // showDialog(
    //   context: context,
    //   barrierDismissible: false,
    //   builder: (BuildContext context) {
    //     return AlertDialog(
    //       content: CircularProgressIndicator(
    //         color: AppColors.primaryColor,
    //       ),
    //     );
    //   },
    // );

    // Call the API
    await courseProvider.fetchEnglishTutorResponse(
        userId, fullName, courseId.toString(), audioFile, "N");

    print("tutor response: ${courseProvider.successResponse?.aiDialogue}");
    Navigator.pop(context);
    // Handle the API response
    if (courseProvider.successResponse != null) {
      // Navigate to TutorScreen on success
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TutorScreen(
            tutorResponse: courseProvider.successResponse!,
          ),
        ),
      );
    } else if (courseProvider.tutorNotSelectedResponse?.errorCode == 210) {
      // Show category dialog if error code is 210
      _dialogBoxForCategory(
          courseProvider.tutorNotSelectedResponse!.courseList);
    } else {
      print("Error occurred during API call");
    }
  }
}

class OptionCards extends StatelessWidget {
  final String? screenName;
  final String title;
  final String subTitle;
  final String imageUrl;
  final Color bgColor;
  final Color opacityColor;
  final VoidCallback onPressed;

  const OptionCards({
    super.key,
    this.screenName,
    required this.title,
    required this.subTitle,
    required this.imageUrl,
    required this.bgColor,
    required this.opacityColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressed();
      },
      child: Card(
        color: bgColor,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0), // Adjust as needed
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Colors.transparent,
                // Start with a transparent color
                opacityColor.withOpacity(0.3),
                // Adjust opacity as needed
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3.0),
                child: Image.asset(
                  imageUrl /*"assets/images/card_images/practice_guided.png"*/,
                  fit: BoxFit.cover,
                  height: 80,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  /*Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      subTitle,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),*/
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ThreeDCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 130,
      decoration: BoxDecoration(
        // color: Color(0xFF1E6751), // dark green color
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 10,
            right: 10,
            child: Container(
              decoration: BoxDecoration(
                // color: Color(0xFF1E6751), // dark green color
                // color: Colors.blueAccent,
                gradient: LinearGradient(
                  begin: Alignment.bottomRight,
                  end: Alignment.centerLeft,
                  colors: [
                    Colors.cyan,
                    // Start with a transparent color
                    Colors.blueAccent,
                    // Adjust opacity as needed
                  ],
                ),
                // color: Colors.blue,
                borderRadius: BorderRadius.circular(12.0),
                /*boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],*/
              ),
              padding: EdgeInsets.all(16),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    // 'Hi, I\'m your Tutor',
                    "Spoken English",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    // 'Start learning with me',
                    "Hi, I\'m your Tutor, Lets Start",
                    style: TextStyle(
                      color: Colors.yellow,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 20,
            bottom: -10,
            child: Image.asset(
              'assets/images/card_images/tutor.png',
              // Replace with your character image
              height: 140,
            ),
          ),
        ],
      ),
    );
  }
}
