import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:markdown_widget/config/configs.dart';
import 'package:markdown_widget/widget/markdown.dart';
import 'package:risho_speech/screens/Common/Shimmer_Arrow.dart';
import 'package:risho_speech/screens/VideoPlayerBoard.dart';

import '../../providers/ieltsCourseLessonProvider.dart';
import '../../ui/colors.dart';

class IeltsCourseBoardMobileScreen extends StatefulWidget {
  final int lessonId;
  final String lessonName;

  const IeltsCourseBoardMobileScreen(
      {super.key, required this.lessonId, required this.lessonName});

  @override
  State<IeltsCourseBoardMobileScreen> createState() =>
      _IeltsCourseBoardMobileScreenState();
}

class _IeltsCourseBoardMobileScreenState
    extends State<IeltsCourseBoardMobileScreen>
    with SingleTickerProviderStateMixin {
  IeltsCourseLessonProvider ieltsCourseLessonProvider =
      IeltsCourseLessonProvider();

  List<Widget> _lessonComponents = [];
  ScrollController _scrollController = ScrollController();

  bool _isLoading = true;
  late TabController _tabController;
  TextEditingController questionTextFieldController = TextEditingController();
  bool _askQuestionActive = false; // To toggle the visibility

  late String sessionIdNew = "";
  late String _question = '';

  @override
  void initState() {
    // TODO: implement initState
    _tabController = TabController(length: 2, vsync: this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.lessonName,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ),
      body: _body(widget.lessonId),
      // SingleChildScrollView(child: _body(widget.lessonId)),
      /*floatingActionButton: _askQuestionActive
          ? null // Hide the FAB when the question box is active
          : FloatingActionButton(
              backgroundColor: AppColors.primaryColor2,
              onPressed: () {
                setState(() {
                  _askQuestionActive = true; // Show the question box
                });
              },
              child: const Icon(
                Icons.chat_bubble_outline_rounded,
                color: Colors.white,
              ),
            ),*/
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        color: AppColors.primaryColor2,
        borderRadius: BorderRadius.circular(64.0),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: TabBar(
        dividerColor: Colors.transparent,
        controller: _tabController,
        indicatorColor: Colors.white,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.black,
        tabs: const [
          Tab(text: 'Lesson'),
          Tab(text: 'Videos'),
        ],
      ),
    );
  }

  Widget _buildTabBarView() {
    return Expanded(
      child: TabBarView(
        controller: _tabController,
        children: [
          // _buildAnswerSheet(),
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height, // Define height here
            child: _lessonContent(),
          ),

          /*Column(
            children: _lessonComponents,
          ),*/
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height, // Define height here
            child: _videoContent(),
          ),
        ],
      ),
    );
  }

  Widget _body(int lessonId) {
    return FutureBuilder<void>(
      future: ieltsCourseLessonProvider.fetchIeltsCourseLesson(lessonId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: SpinKitThreeInOut(
              color: AppColors.primaryColor,
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final lessoncontent = ieltsCourseLessonProvider
              .ieltsCourseLessonResponse?.lessonContent;
          final lessonAnsId =
              ieltsCourseLessonProvider.ieltsCourseLessonResponse?.lessonAnsId;
          final videoLessonList =
              ieltsCourseLessonProvider.ieltsCourseLessonResponse?.videoList;

          /*_lessonComponents.add(
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: MarkdownWidget(
                data: ieltsCourseLessonProvider
                    .ieltsCourseLessonResponse!.lessonContent
                    .toString(),
                config: config,
              ),
            ),
          );*/
          return Stack(
            children: [
              Positioned(
                bottom: 50,
                right: 20,
                child: ShimmerArrow(),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    _buildTabBar(),
                    _buildTabBarView(),
                  ],
                ),
              ),

              /// Animated Container for the question box
              /// need to implement afterward

              /*Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.fastOutSlowIn,
                  width: _askQuestionActive
                      ? MediaQuery.of(context).size.width
                      : 0.0,
                  height: _askQuestionActive ? 80.0 : 0.0,
                  color: AppColors.backgroundColorDark,
                  // Background color for the question box
                  padding: const EdgeInsets.all(10.0),
                  child: _askQuestionActive
                      ? Row(
                          children: [
                            */ /* Question Box */ /*
                            Expanded(
                              child: TextField(
                                controller: questionTextFieldController,
                                maxLines: 3,
                                minLines: 1,
                                cursorColor: AppColors.primaryColor,
                                decoration: const InputDecoration(
                                  hintText: 'Ask anything about this lesson',
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50.0)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(40.0)),
                                    borderSide: BorderSide(
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                ),
                                onChanged: (value) {
                                  _question = value;
                                },
                              ),
                            ),
                            const SizedBox(width: 2),
                            */ /* Send Button */ /*
                            IconButton.filledTonal(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.backgroundColorDark,
                              ),
                              onPressed: () {
                                setState(() {
                                  // Add your logic to send the message
                                  questionTextFieldController.clear();
                                  _askQuestionActive =
                                      false; // Hide the question box
                                });
                              },
                              icon: const Icon(
                                Iconsax.direct_right,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ],
                        )
                      : Container(),
                ),
              ),*/
            ],
          );
        }
      },
    );
  }

  final config = MarkdownConfig.darkConfig;

  /*Widget _lessonContent() {
    return Column(
      children: [
        _lessonComponents.add(
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: MarkdownWidget(
              data: ieltsCourseLessonProvider
                  .ieltsCourseLessonResponse!.lessonContent
                  .toString(),
              config: config,
            ),
          ),
        )
      ],
    );
  }*/
  Widget _lessonContent() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10.0),
      child: MarkdownWidget(
        data: ieltsCourseLessonProvider.ieltsCourseLessonResponse!.lessonContent
            .toString(),
        config: config,
      ),

      // After the Markdown widget, display the other lesson components
    );
  }

  Widget _videoContent() {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      itemCount:
          ieltsCourseLessonProvider.ieltsCourseLessonResponse!.videoList.length,
      itemBuilder: (context, index) {
        final video = ieltsCourseLessonProvider
            .ieltsCourseLessonResponse!.videoList[index];
        return GestureDetector(
          onTap: () {
            // Fluttertoast.showToast(msg: video.lessonId.toString());
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => VideoPlayerBoard(
                      videoUrl: video.videoUrl,
                      videoTitle: video.videoTitle,
                      isVideo: "Y",
                      lessonContentId: video.videoId)),
            );
          },
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 5.0),
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: AppColors.vocabularyCatCardColor,
              borderRadius: BorderRadius.circular(6.0),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  "assets/images/youtube_icon.png",
                  width: 34,
                  height: 34,
                ),
                SizedBox(width: 8.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        video.videoTitle,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 1,
                          ),
                          Text(
                            "Duration: ${video.videoDuration} minutes",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
