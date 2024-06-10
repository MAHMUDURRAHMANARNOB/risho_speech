import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:risho_speech/screens/CallingAgentScreen.dart';
import 'package:risho_speech/screens/PracticeGuidedScreen.dart';
import 'package:risho_speech/screens/VocabulatyCategoryScreen.dart';
import 'package:risho_speech/ui/colors.dart';

import '../../providers/auth_provider.dart';
import '../../providers/subscriptionStatus_provider.dart';
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
      margin: EdgeInsets.all(10),
      child: Container(
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
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    subTitle,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

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

  // late final userId;

  @override
  Widget build(BuildContext context) {
    // final userId = Provider.of<AuthProvider>(context).user?.id;
    // subscriptionStatusProvider.fetchSubscriptionData(userId!);

    return SafeArea(
      child: SingleChildScrollView(
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
                    Text(
                      "Hello",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      "${Provider.of<AuthProvider>(context).user?.name ?? 'UserName'}",
                      style: TextStyle(
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
              margin: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
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
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "$audioRemains",
                                style: TextStyle(
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24),
                              ),
                              Text(
                                "Minutes Remaining",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PackagesScreen()),
                      );
                    },
                    child: Text(
                      "Add Minutes",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

            /*Conversation Card*/
            Container(
              margin: EdgeInsets.fromLTRB(8.0, 5.0, 8.0, 5.0),
              child: GestureDetector(
                onTap: () {
                  // double audioRemains = subscriptionStatusProvider.audioRemains;
                  double audioRemains = Provider.of<SubscriptionStatusProvider>(
                          context,
                          listen: false)
                      .audioRemains;
                  // debugPrint(audioRemains.toString());
                  if (audioRemains > 0.0) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PracticeGuidedScreen(
                                screenName: 'PDL',
                              )),
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Limit expired'),
                        content: Text(
                            'You have no audio minutes remains. Please purchase more.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(
                              'OK',
                              style: TextStyle(color: AppColors.secondaryColor),
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const PackagesScreen()),
                            ),
                            child: Text(
                              'Purchase',
                              style: TextStyle(color: AppColors.primaryColor),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
                child: Card(
                  color: Colors.redAccent,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(8.0), // Adjust as needed
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Colors.transparent, // Start with a transparent color
                          Colors.white
                              .withOpacity(0.3), // Adjust opacity as needed
                        ],
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Practice Daily Lesson",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const PracticeGuidedScreen(
                                              screenName: 'PDL',
                                            )),
                                  );
                                },
                                /*style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryContainerColor,
                                  padding: EdgeInsets.all(10.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                ),*/
                                icon: Icon(
                                  Icons.arrow_circle_right_rounded,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Image.asset(
                            "assets/images/card_images/practice_guided.png",
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            /*IMPROVE PRONUNCIATION*/
            Container(
              margin: EdgeInsets.fromLTRB(8.0, 5.0, 8.0, 5.0),
              child: GestureDetector(
                onTap: () {
                  double audioRemains = Provider.of<SubscriptionStatusProvider>(
                          context,
                          listen: false)
                      .audioRemains;
                  if (audioRemains > 0.0) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PracticeGuidedScreen(
                                screenName: 'IP',
                              )),
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Limit expired'),
                        content: Text(
                            'You have no audio minutes remains. Please purchase more.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(
                              'OK',
                              style: TextStyle(color: AppColors.secondaryColor),
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const PackagesScreen()),
                            ),
                            child: Text(
                              'Purchase',
                              style: TextStyle(color: AppColors.primaryColor),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
                child: Card(
                  color: Colors.orangeAccent,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(8.0), // Adjust as needed
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Colors.transparent, // Start with a transparent color
                          Colors.amberAccent
                              .withOpacity(0.3), // Adjust opacity as needed
                        ],
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Improve Pronunciation",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const PracticeGuidedScreen(
                                              screenName: 'IP',
                                            )),
                                  );
                                },
                                /*style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryContainerColor,
                                  padding: EdgeInsets.all(10.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                ),*/
                                icon: Icon(
                                  Icons.arrow_circle_right_rounded,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Image.asset(
                            "assets/images/card_images/improve_speaking.png",
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            /*Container(
              margin: EdgeInsets.fromLTRB(8.0, 5.0, 8.0, 5.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PracticeGuidedScreen(
                              screenName: 'IP',
                            )),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryContainerColor,
                  padding: EdgeInsets.all(10.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          "assets/images/Pronunciation.png",
                          width: 30,
                          height: 30,
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          "Improve Pronunciation",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.backgroundColorDark,
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.arrow_circle_right_rounded,
                      size: 30,
                      color: AppColors.primaryColor,
                    ),
                  ],
                ),
              ),
            ),*/
            /*Vocabulary*/
            Container(
              margin: EdgeInsets.fromLTRB(8.0, 5.0, 8.0, 5.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => VocabularyCategoryScreen()),
                  );
                },
                child: Card(
                  color: Colors.cyan,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(8.0), // Adjust as needed
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Colors.transparent, // Start with a transparent color
                          Colors.blueAccent
                              .withOpacity(0.3), // Adjust opacity as needed
                        ],
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Practice Vocabulary",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            VocabularyCategoryScreen()),
                                  );
                                },
                                /*style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryContainerColor,
                                  padding: EdgeInsets.all(10.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                ),*/
                                icon: Icon(
                                  Icons.arrow_circle_right_rounded,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Image.asset(
                            "assets/images/card_images/practice_vocabulary.png",
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            /*Container(
              margin: EdgeInsets.fromLTRB(8.0, 5.0, 8.0, 5.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => VocabularyCategoryScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryContainerColor,
                  padding: EdgeInsets.all(10.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          "assets/images/topic.png",
                          width: 30,
                          height: 30,
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          "Practice Vocabulary",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.backgroundColorDark,
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.arrow_circle_right_rounded,
                      size: 30,
                      color: AppColors.primaryColor,
                    ),
                  ],
                ),
              ),
            ),*/

            /*Call*/
            Container(
              margin: EdgeInsets.fromLTRB(8.0, 5.0, 8.0, 5.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CallingAgentScreen()),
                  );
                },
                child: Card(
                  color: Colors.lime,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(8.0), // Adjust as needed
                      gradient: LinearGradient(
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                        colors: [
                          Colors.transparent, // Start with a transparent color
                          AppColors.primaryColor
                              .withOpacity(0.3), // Adjust opacity as needed
                        ],
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Phone Call",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CallingAgentScreen()),
                                  );
                                },
                                /*style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryContainerColor,
                                  padding: EdgeInsets.all(10.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                ),*/
                                icon: Icon(
                                  Icons.arrow_circle_right_rounded,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Image.asset(
                            "assets/images/card_images/make_phone_call.png",
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            /*Container(
              margin: EdgeInsets.fromLTRB(8.0, 5.0, 8.0, 5.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CallingAgentScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan[50],
                  padding: EdgeInsets.all(10.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          "assets/images/phone_call.png",
                          width: 30,
                          height: 30,
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          "Phone Call",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.backgroundColorDark,
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.arrow_circle_right_rounded,
                      size: 30,
                      color: AppColors.primaryColor,
                    ),
                  ],
                ),
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}
