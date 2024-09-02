import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iconsax/iconsax.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';
import 'package:risho_speech/screens/CallingAgentScreen.dart';
import 'package:risho_speech/screens/IeltsAssistantScreen.dart';
import 'package:risho_speech/screens/Mobile/IELTSHomeScreenMobile.dart';
import 'package:risho_speech/screens/PracticeGuidedScreen.dart';
import 'package:risho_speech/screens/VocabularyCategoryScreen.dart';
import 'package:risho_speech/ui/colors.dart';
import 'package:risho_speech/utils/constants/colors.dart';

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
  late String userName;

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
                            Provider.of<AuthProvider>(context).user?.name ??
                                'UserName',
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

                  /*Practice Daily lesson*/
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        // double audioRemains = subscriptionStatusProvider.audioRemains;
                        double audioRemains =
                            Provider.of<SubscriptionStatusProvider>(context,
                                    listen: false)
                                .audioRemains;
                        // debugPrint(audioRemains.toString());
                        if (audioRemains > 0.0) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const PracticeGuidedScreen(
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
                        color: AppColors.primaryColor,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(8.0), // Adjust as needed
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Colors.transparent,
                                // Start with a transparent color
                                Colors.white.withOpacity(0.3),
                                // Adjust opacity as needed
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
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        "Start Speaking",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        "Practice speaking on real life scenarios with AI ",
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
                                flex: 1,
                                child: Image.asset(
                                  "assets/images/card_images/practice_guided.png",
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

                  /*IMPROVE PRONUNCIATION / Speech Trainer*/
                  Container(
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
                        color: AppColors.orange,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(8.0), // Adjust as needed
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Colors.transparent,
                                // Start with a transparent color
                                Colors.lime.withOpacity(0.3),
                                // Adjust opacity as needed
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
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        "Speech Trainer",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        "Learn how to pronounce sentences.",
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
                                flex: 1,
                                child: Image.asset(
                                  "assets/images/card_images/improve_speaking.png",
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
                  /*IELTS*/
                  Container(
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
                            borderRadius:
                                BorderRadius.circular(8.0), // Adjust as needed
                            gradient: LinearGradient(
                              begin: Alignment.centerRight,
                              end: Alignment.centerLeft,
                              colors: [
                                Colors.transparent,
                                // Start with a transparent color
                                Colors.red.withOpacity(0.3),
                                // Adjust opacity as needed
                              ],
                            ),
                          ),
                          child: Row(
                            children: [
                              const Expanded(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        "IELTS Preparation",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        "Get ready for your IELTS exam with Risho",
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
                                flex: 1,
                                child: Image.asset(
                                  "assets/images/ielts/ielts_icon.png",
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
        floatingActionButton: FloatingActionButton(
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
          child: Image.asset("assets/images/bot.gif", width: 30, height: 30),
        ),
      ),
    );
  }
}
