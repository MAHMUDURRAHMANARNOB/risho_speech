import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../CallingAgentScreen.dart';
import '../Common/ContainerCard.dart';
import '../PracticeGuidedScreen.dart';
import '../VocabulatyCategoryScreen.dart';

class HomeScreenTablet extends StatefulWidget {
  const HomeScreenTablet({super.key});

  @override
  State<HomeScreenTablet> createState() => _HomeScreenTabletState();
}

class _HomeScreenTabletState extends State<HomeScreenTablet> {
  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<AuthProvider>(context).user?.id;

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            /*TOP Greetings*/
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  /*Image.asset(
                    "assets/images/risho_guru_icon.png",
                    width: 50,
                    height: 40,
                  ),*/
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PracticeGuidedScreen(
                                  screenName: 'PDL',
                                )),
                      );
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PracticeGuidedScreen(
                                  screenName: 'IP',
                                )),
                      );
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CallingAgentScreen()),
                      );
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
