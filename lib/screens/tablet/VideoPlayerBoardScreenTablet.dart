import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iconsax/iconsax.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:markdown_widget/config/configs.dart';
import 'package:markdown_widget/widget/markdown.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../providers/IeltsCourseVideoAnsProvider.dart';
import '../../providers/auth_provider.dart';
import '../../ui/colors.dart';
import '../packages_screen.dart';

class VideoPlayerBoardScreenTablet extends StatefulWidget {
  final String videoUrl;
  final String videoTitle;
  final String isVideo;
  final int lessonContentId;

  const VideoPlayerBoardScreenTablet(
      {super.key,
      required this.videoUrl,
      required this.videoTitle,
      required this.isVideo,
      required this.lessonContentId});

  @override
  State<VideoPlayerBoardScreenTablet> createState() =>
      _VideoPlayerBoardScreenTabletState();
}

class _VideoPlayerBoardScreenTabletState
    extends State<VideoPlayerBoardScreenTablet> {
  List<Widget> _lessonComponents = [];
  ScrollController _scrollController = ScrollController();
  late YoutubePlayerController _controller;
  TextEditingController questionTextFieldController = TextEditingController();
  late AuthProvider authController =
      Provider.of<AuthProvider>(context, listen: false);

  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;
  late int userId = authController.user!.id ?? 123;
  double _volume = 100;
  bool _muted = false;
  bool _isPlayerReady = false;
  IeltsLessonReplyProvider ieltsLessonReplyProvider =
      IeltsLessonReplyProvider();

  @override
  void initState() {
    // TODO: implement initState

    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.videoUrl)!,
      flags: YoutubePlayerFlags(
        // autoPlay: false,
        showLiveFullscreenButton: false,
        // useHybridComposition: true,
        autoPlay: false,
        mute: false,
        isLive: false,
      ),
    );
    super.initState();
  }

  late String sessionIdNew = "";
  late String _question = '';

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final userId = Provider.of<AuthProvider>(context).user?.id ?? 1;
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          "Video Lesson Board",
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /*Video*/
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  YoutubePlayer(
                    controller: _controller,
                    showVideoProgressIndicator: true,
                    // onReady: () => debugPrint("Ready"),
                    bottomActions: const [
                      CurrentPosition(),
                      ProgressBar(
                        isExpanded: true,
                        colors: ProgressBarColors(
                          playedColor: AppColors.primaryColor,
                          handleColor: AppColors.primaryColor,
                        ),
                      ),
                      // PlaybackSpeedButton(),
                      RemainingDuration(),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      widget.videoTitle,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // ANSWERS
            _lessonComponents.isNotEmpty
                ? Column(
                    children: _lessonComponents,
                  )
                : Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.primaryCardColor,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      margin: EdgeInsets.all(8),
                      padding: EdgeInsets.all(16),
                      child: const Column(
                        children: [
                          Text(
                            "Feel Free to Ask Anything About this Video",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Icon(
                            Iconsax.arrow_down,
                            color: AppColors.primaryColor,
                            size: 50,
                          ),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
      /* Floating Action Button to open the dialog */
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primaryColor2,
        label: Row(
          children: [
            Text(
              "Ask about this video",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(width: 5.0),
            const Icon(
              IconsaxPlusBold.message_question,
              color: Colors.white,
            ),
          ],
        ),
        // FAB Icon
        onPressed: () {
          _showQuestionDialog(context); // Call the dialog method
        },
      ),
    );
  }

  /* Method to show the dialog */
  void _showQuestionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: const Text("Ask a Question"),
          content: TextField(
            controller: questionTextFieldController,
            maxLines: 3,
            minLines: 1,
            cursorColor: AppColors.primaryColor,
            decoration: const InputDecoration(
              hintText: 'Ask anything about this video',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                borderSide: BorderSide(
                  color: AppColors.primaryColor,
                ),
              ),
            ),
            onChanged: (value) {
              _question = value;
            },
          ),
          actions: <Widget>[
            /* Cancel Button */
            TextButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondaryColor.withOpacity(
                  0.2,
                ),
              ),
              child: const Text(
                "Cancel",
                style: TextStyle(
                  color: AppColors.secondaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            /* Send Button */
            TextButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor2.withOpacity(
                  0.2,
                ),
              ),
              child: const Text(
                "Send",
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                setState(() {
                  questionTextFieldController.clear();
                  _lessonComponents.add(
                    _generateAnswerResponse(
                      widget.lessonContentId,
                      _question,
                      userId.toString(),
                      "Y",
                      sessionIdNew,
                    ),
                  );
                });
                Navigator.of(context).pop(); // Close the dialog after sending
              },
            ),
          ],
        );
      },
    );
  }

  Widget _generateAnswerResponse(
    int lessoncontentID,
    String question,
    String userid,
    String isVideo,
    String? sessionID,
  ) {
    bool _isPressed = false;
    print("Pressed");

    return FutureBuilder<void>(
      future: ieltsLessonReplyProvider.fetchIeltsLessonReply(
          lessoncontentID, question, userid, isVideo, sessionID),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SpinKitThreeInOut(
            color: AppColors.primaryColor,
          ); // Loading state
        } else if (snapshot.hasError) {
          return Container(
            margin: const EdgeInsets.all(5.0),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: AppColors.primaryCardColor,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    "Sorry: ${ieltsLessonReplyProvider.ieltsCourseListResponse!.message ?? "Server error"}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          if (ieltsLessonReplyProvider.ieltsCourseListResponse != null &&
              ieltsLessonReplyProvider.ieltsCourseListResponse!.errorCode ==
                  200) {
            final response = ieltsLessonReplyProvider.ieltsCourseListResponse;
            final lessonAnswer = response!.answerText;
            sessionIdNew =
                ieltsLessonReplyProvider.ieltsCourseListResponse!.sessionId;
            print(sessionIdNew);

            // final ticketId = response.ticketId!;
            return Container(
              width: double.infinity,
              margin: const EdgeInsets.all(5.0),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /*Top Part*/
                  Container(
                    width: double.infinity,
                    child: Text(
                      "Question: $question",
                      softWrap: true,
                      style: const TextStyle(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Container(
                    width: double.infinity,
                    // margin: const EdgeInsets.all(10.0),
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundColorDark,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: MarkdownWidget(
                      data: lessonAnswer,
                      shrinkWrap: true,
                      selectable: true,
                      config: MarkdownConfig.darkConfig,
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Container(
              margin: const EdgeInsets.all(5.0),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: AppColors.primaryCardColor,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      "Sorry: ${ieltsLessonReplyProvider.ieltsCourseListResponse!.message}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryCardColor),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PackagesScreen()),
                        );
                      },
                      child: const Text(
                        "Buy Subscription",
                        style: TextStyle(
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        }
      },
    );
  }
}
