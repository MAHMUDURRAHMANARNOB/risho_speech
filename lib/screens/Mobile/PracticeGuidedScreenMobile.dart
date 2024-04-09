import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:risho_speech/screens/ChatScreen.dart';
import 'package:risho_speech/ui/colors.dart';

import '../../providers/auth_provider.dart';
import '../../providers/doConversationProvider.dart';
import '../../providers/spokenLessonListProvider.dart';

class PracticeGuidedScreenMobile extends StatefulWidget {
  const PracticeGuidedScreenMobile({super.key});

  @override
  State<PracticeGuidedScreenMobile> createState() =>
      _PracticeGuidedScreenMobileState();
}

class _PracticeGuidedScreenMobileState
    extends State<PracticeGuidedScreenMobile> {
  final SpokenLessonListProvider spokenLessonListProvider =
      SpokenLessonListProvider();
  final DoConversationProvider doConversationProvider =
      DoConversationProvider();

  @override
  Widget build(BuildContext context) {
    bool isLoading = false;
    String? sessionId;
    String? aiDialogue;
    String? aiDialogueAudio;
    String? aiTranslation;
    final randomColor =
        Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
    final username =
        Provider.of<AuthProvider>(context).user?.name ?? 'UserName';

    void fetchSessionId(int userId, int conversationId) async {
      showDialog(
        context: context,
        barrierDismissible: false, // Prevent dialog dismissal
        builder: (BuildContext context) {
          return Center(
            child: SpinKitChasingDots(
              color: Colors.green,
            ), // Show loader
          );
        },
      );

      try {
        var response = await doConversationProvider.fetchConversationResponse(
            userId, conversationId, null, null, '', '', '', username);
        setState(() {
          sessionId = response['SessionID'];
          aiDialogue = response['AIDialoag'];
          aiDialogueAudio = response['AIDialoagAudio'];
          aiTranslation = response['AIDialoagBn'];
          isLoading = false;
        });
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChatScreen(
                    id: conversationId,
                    sessionId: sessionId!,
                    aiDialogue: aiDialogue!,
                    aiDialogueAudio: aiDialogueAudio!,
                    aiTranslation: aiTranslation ?? "Not found",
                  )),
        );
        /*showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Success"),
              content: Text("New Session Started $sessionId "),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );*/
        print("$sessionId, $aiDialogue");
      } catch (e) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text(e.toString()),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
        // Handle error
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Practice Guided Lesson",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: FutureBuilder<void>(
          future: spokenLessonListProvider.fetchSpokenLessonListResponse(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: const SpinKitThreeInOut(
                  color: AppColors.primaryColor,
                ),
              );
            } else if (snapshot.hasError) {
              // Handle error
              return Center(
                child: Text("No Data Found"),
              );
            } else {
              return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Number of items in each row
                    crossAxisSpacing:
                        10.0, // Spacing between items horizontally
                    mainAxisSpacing: 10.0, // Spacing between items vertically
                  ),
                  itemCount: spokenLessonListProvider
                      .spokenLessonListResponse!.lessons.length,
                  itemBuilder: (context, index) {
                    final lesson = spokenLessonListProvider
                        .spokenLessonListResponse!.lessons[index];
                    /*final randomColor =
                        Color((Random().nextDouble() * 0xFFFFFF).toInt())
                            .withOpacity(1.0);*/
                    final randomColor = Color.fromARGB(
                      255,
                      Random().nextInt(128), // Red component
                      Random().nextInt(128), // Green component
                      Random().nextInt(128), // Blue component
                    );
                    return GestureDetector(
                      onTap: () async {
                        fetchSessionId(1, lesson.id);
                      },
                      child: Container(
                        margin: EdgeInsets.all(10.0),
                        // width: 150,
                        width: MediaQuery.of(context).size.width * 0.4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          /*gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.secondaryCardColorGreenish,
                              Colors.cyan,
                            ],
                          ),*/
                          color: Colors.cyan.withOpacity(0.7),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    10.0, 10.0, 0.0, 0.0),
                                child: Text(
                                  lesson
                                      .conversationName, // Display conversationName
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                padding: EdgeInsets.fromLTRB(5.0, 5.0, 5, 5),
                                // margin: EdgeInsets.all(value),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(8.0),
                                        bottomRight: Radius.circular(8.0)),
                                    color: AppColors.cardbasic),
                                child: Text(
                                  lesson
                                      .conversationDetails, // Display conversationName
                                  textAlign: TextAlign.justify,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            }
          },
        ));
  }
}
