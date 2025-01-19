import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:provider/provider.dart';
import 'package:risho_speech/providers/doGuidedConversationProvider.dart';
import 'package:risho_speech/screens/ChatScreen.dart';
import 'package:risho_speech/screens/PronunciationScreen.dart';
import 'package:risho_speech/ui/colors.dart';

import '../../providers/auth_provider.dart';
import '../../providers/doConversationProvider.dart';
import '../../providers/spokenLessonListProvider.dart';
import '../Common/circular_container.dart';

class PracticeGuidedScreenTablet extends StatefulWidget {
  final String screenName;

  const PracticeGuidedScreenTablet({super.key, required this.screenName});

  @override
  State<PracticeGuidedScreenTablet> createState() =>
      _PracticeGuidedScreenTabletState();
}

class _PracticeGuidedScreenTabletState
    extends State<PracticeGuidedScreenTablet> {
  final SpokenLessonListProvider spokenLessonListProvider =
      SpokenLessonListProvider();
  final DoConversationProvider doConversationProvider =
      DoConversationProvider();
  final DoGuidedConversationProvider doGuidedConversationProvider =
      DoGuidedConversationProvider();

  @override
  Widget build(BuildContext context) {
    bool isLoading = false;
    String? sessionId;
    String? aiDialogue;
    String? aiDialogueAudio;
    String? aiTranslation;
    String? isFemale;

    int? dialogId;
    String? actorName;
    String? conversationEn;
    String? conversationBn;
    int? seqNumber;
    String? conversationDetails;
    String? conversationAudioFile;
    String? discussionTopic;
    String? discusTitle;

    final screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount;
    if (screenWidth <= 900) {
      crossAxisCount = 4;
    } else if (screenWidth <= 1100) {
      crossAxisCount = 5;
    } else {
      crossAxisCount = 6; // You can set any default value for larger screens
    }

    final randomColor =
        Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
    final username =
        Provider.of<AuthProvider>(context).user?.name ?? 'UserName';
    final userId = Provider.of<AuthProvider>(context).user?.id ?? 1;
    late String screenName;
    late String screenTitle;

    /*Practice Daily Lessons*/
    void fetchSessionId(int userId, int conversationId) async {
      showDialog(
        context: context,
        barrierDismissible: false, // Prevent dialog dismissal
        builder: (BuildContext context) {
          return const Center(
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
          actorName = response['actorName'];
          aiTranslation = response['AIDialoagBn'];
          isFemale = response['isFemale'];
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
                    actorName: actorName ?? "Not found",
                    isFemale: isFemale ?? "N",
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
              title: const Text("Error"),
              content: Text(e.toString()),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );
        // Handle error
      }
    }

    /*Improve Pronunciation*/
    void fetchDialogId(int userId, int conversationId) async {
      showDialog(
        context: context,
        barrierDismissible: false, // Prevent dialog dismissal
        builder: (BuildContext context) {
          return Center(
            child: SpinKitChasingDots(
              color: Colors.amberAccent,
            ), // Show loader
          );
        },
      );

      try {
        var response =
            await doGuidedConversationProvider.fetchGuidedConversationResponse(
                userId, conversationId, null, null, '', '', '', username, 1);
        setState(() {
          // sessionId = response['SessionID'];
          dialogId = response['dialogid'];
          actorName = response['actorName'];
          conversationEn = response['conversationEn'];
          conversationBn = response['conversationBn'];
          seqNumber = response['seqNumber'];
          conversationDetails = response['conversationDetails'];
          conversationAudioFile = response['conversationAudioFile'];
          discussionTopic = response['discussionTopic'];
          discusTitle = response['discusTitle'];
          isLoading = false;
        });
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PronunciationScreen(
                    conversationId: conversationId,
                    dialogId: dialogId!,
                    conversationEn: conversationEn!,
                    conversationBn: conversationBn!,
                    conversationAudioFile: conversationAudioFile!,
                    seqNumber: seqNumber!,
                    conversationDetails: conversationDetails!,
                    discussionTopic: discussionTopic!,
                    discusTitle: discusTitle!,
                    actorName: actorName!,
                  )),
        );
        /*showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Success"),
              content: Column(
                children: [
                  Text("New Session Started $dialogId "),
                  Text("SequenceNo $seqNumber "),
                  Text("Actor Name $actorName "),
                  Text("Conversation \n$conversationEn "),
                  Text("Translation \n$conversationBn "),
                  Text("Conversation Details $conversationDetails "),
                  Text("Discussion Topic $discussionTopic "),
                  Text("Discussion Title $discusTitle "),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );*/
        // print("$sessionId, $aiDialogue");
      } catch (e) {
        Navigator.pop(context);
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

    if (widget.screenName == "PDL") {
      setState(() {
        screenName = "Practice Daily Lesson";
        screenTitle =
            "Practice Real-Life scenarios and speak freely to boost your confidence in conversations!";
      });
    } else if (widget.screenName == "IP") {
      setState(() {
        screenName = "Improve Pronunciation";
        screenTitle =
            "Learn how to speak in Real-Life scenarios by mimicking RISHO and boost your confidence!";
      });
    } else {
      setState(() {
        screenName = "Not Found";
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          screenName,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Container(
        // color: AppColors.primaryColor,
        child: FutureBuilder<void>(
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
              final lessons = List.of(
                  spokenLessonListProvider.spokenLessonListResponse!.lessons)
                ..shuffle();

              return SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        screenTitle,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          // Number of items in each row
                          crossAxisSpacing: 10.0,
                          // Spacing between items horizontally
                          mainAxisSpacing:
                              10.0, // Spacing between items vertically
                        ),
                        itemCount: lessons.length,
                        itemBuilder: (context, index) {
                          final lesson = lessons[index];

                          return GestureDetector(
                            onTap: () async {
                              if (widget.screenName == "PDL") {
                                fetchSessionId(userId, lesson.id);
                              } else if (widget.screenName == "IP") {
                                fetchDialogId(userId, lesson.id);
                              } else {
                                print("screenName error");
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.all(5.0),
                              width: MediaQuery.of(context).size.width * 0.4,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: /*AppColors.primaryColor2*/
                                    Colors.blue,
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    top: -180,
                                    right: -250,
                                    child: TCircularContainer(
                                      backgroundColor: AppColors
                                          .backgroundColorDark
                                          .withOpacity(0.2),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(10.0),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(64),
                                                color: AppColors
                                                    .backgroundColorDark
                                                    .withOpacity(0.5),
                                              ),
                                              child: const Icon(
                                                IconsaxPlusBold.book,
                                                size: 30.0,
                                              ),
                                            ),
                                            SizedBox(height: 5.0),
                                            Text(
                                              lesson.conversationName,
                                              textAlign: TextAlign.start,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 5.0, horizontal: 10.0),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            color: AppColors.backgroundColorDark
                                                .withOpacity(0.5),
                                          ),
                                          child: Text(
                                            lesson.userLevel,
                                            textAlign: TextAlign.start,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
