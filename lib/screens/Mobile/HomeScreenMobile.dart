import 'package:flutter/material.dart';
import 'package:risho_speech/screens/PracticeGuidedScreen.dart';
import 'package:risho_speech/ui/colors.dart';

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
                  height: 50,
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
                      "User full name",
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
            Container(
              margin: EdgeInsets.fromLTRB(8.0, 5.0, 8.0, 5.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PracticeGuidedScreen()),
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
            Container(
              margin: EdgeInsets.fromLTRB(8.0, 5.0, 8.0, 5.0),
              child: ElevatedButton(
                onPressed: () {
                  /*Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PackagesScreen()),
                  );*/
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
            Container(
              margin: EdgeInsets.fromLTRB(8.0, 5.0, 8.0, 5.0),
              child: ElevatedButton(
                onPressed: () {
                  /*Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PackagesScreen()),
                  );*/
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
                          "Study by Topic",
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
            Container(
              margin: EdgeInsets.fromLTRB(8.0, 5.0, 8.0, 5.0),
              child: ElevatedButton(
                onPressed: () {
                  /*Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PackagesScreen()),
                  );*/
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
                          "Practice Conversation",
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
