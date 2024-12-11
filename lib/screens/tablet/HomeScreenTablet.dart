import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/subscriptionStatus_provider.dart';
import '../../ui/colors.dart';
import '../CallingAgentScreen.dart';
import '../Common/ContainerCard.dart';
import '../Mobile/SubscriptionScreenIOS.dart';
import '../PracticeGuidedScreen.dart';
import '../VocabularyCategoryScreen.dart';
import '../packages_screen.dart';

class HomeScreenTablet extends StatefulWidget {
  const HomeScreenTablet({super.key});

  @override
  State<HomeScreenTablet> createState() => _HomeScreenTabletState();
}

class _HomeScreenTabletState extends State<HomeScreenTablet> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = Provider.of<AuthProvider>(context, listen: false).user?.id;
      if (userId != null) {
        Provider.of<SubscriptionStatusProvider>(context, listen: false)
            .fetchSubscriptionData(userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // final userId = Provider.of<AuthProvider>(context).user?.id;

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            /*TOP Greetings*/
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
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
                            builder: (context) => Platform.isIOS
                                ? SubscriptionScreenIOS()
                                : PackagesScreen()),
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
            /*Option Buttons*/
            Row(
              children: [
                /*Conversation Card*/
                Expanded(
                  flex: 1,
                  child: ContainerCard(
                    image: "assets/images/card_images/practice_guided.png",
                    title: 'Practice Daily Lesson',
                    subTitle: '',
                    color: Colors.redAccent,
                    onPressed: () {
                      double audioRemains =
                          Provider.of<SubscriptionStatusProvider>(context,
                                  listen: false)
                              .audioRemains;
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
                                child: Text(
                                  'Purchase',
                                  style:
                                      TextStyle(color: AppColors.primaryColor),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                ),
                /*IMPROVE PRONUNCIATION*/
                Expanded(
                  flex: 1,
                  child: ContainerCard(
                    image: "assets/images/card_images/improve_speaking.png",
                    title: 'Improve Pronunciation',
                    color: Colors.orangeAccent,
                    subTitle: '',
                    onPressed: () {
                      double audioRemains =
                          Provider.of<SubscriptionStatusProvider>(context,
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
                                child: Text(
                                  'Purchase',
                                  style:
                                      TextStyle(color: AppColors.primaryColor),
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
            Row(
              children: [
                /*Vocabulary*/
                Expanded(
                  flex: 1,
                  child: ContainerCard(
                    image: "assets/images/card_images/practice_vocabulary.png",
                    title: 'Practice Vocabulary',
                    color: Colors.cyan,
                    subTitle: '',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => VocabularyCategoryScreen()),
                      );
                    },
                  ),
                ),
                /*Call*/
                Expanded(
                  flex: 1,
                  child: ContainerCard(
                    image: "assets/images/card_images/make_phone_call.png",
                    title: 'Phone Call',
                    color: Colors.lime,
                    subTitle: '',
                    onPressed: () {
                      double audioRemains =
                          Provider.of<SubscriptionStatusProvider>(context,
                                  listen: false)
                              .audioRemains;
                      if (audioRemains > 0.0) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CallingAgentScreen()),
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
                                child: Text(
                                  'Purchase',
                                  style:
                                      TextStyle(color: AppColors.primaryColor),
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
          ],
        ),
      ),
    );
  }
}
