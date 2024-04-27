import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:risho_speech/screens/CallingAgentScreen.dart';
import 'package:risho_speech/screens/PracticeGuidedScreen.dart';
import 'package:risho_speech/screens/VocabulatyCategoryScreen.dart';
import 'package:risho_speech/ui/colors.dart';

import '../../providers/auth_provider.dart';

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

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<AuthProvider>(context).user?.id;

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
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

            /*Conversation Card*/
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Conversation with Risho",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ReuseableCard(
                          "assets/images/card_img_one.png",
                          "TITLE",
                          "subTitle",
                        ),
                        ReuseableCard(
                          "assets/images/card_img_one.png",
                          "TITLE",
                          "subTitle",
                        ),
                        ReuseableCard(
                          "assets/images/card_img_one.png",
                          "TITLE",
                          "subTitle",
                        ),
                        ReuseableCard(
                          "assets/images/card_img_one.png",
                          "TITLE",
                          "subTitle",
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "See more",
                                style: TextStyle(color: AppColors.primaryColor),
                              ),
                              Icon(
                                Icons.chevron_right,
                                color: AppColors.primaryColor,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            /*Options*/
            /*PRACTICE DAILY LESSON*/
            Container(
              margin: EdgeInsets.fromLTRB(8.0, 5.0, 8.0, 5.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PracticeGuidedScreen(
                              screenName: 'PDL',
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
                          "assets/images/practice.png",
                          width: 30,
                          height: 30,
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          "Practice Daily Lessons",
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
            ),
            /*IMPROVE PRONUNCIATION*/
            Container(
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
            ),
            /*Vocabulary*/
            Container(
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
            ),
            /*Call*/
            Container(
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
            ),
          ],
        ),
      ),
    );
  }
}
