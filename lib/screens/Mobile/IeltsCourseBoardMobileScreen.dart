import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:markdown_widget/widget/markdown.dart';

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
  bool _isLoading = true;
  late TabController _tabController;

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
          _lessonContent(),
          _videoContent()
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

          return Column(
            children: [
              _buildTabBar(),
              _buildTabBarView(),
            ],
          );
        }
      },
    );
  }

  Widget _lessonContent() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: MarkdownWidget(
          data: ieltsCourseLessonProvider
              .ieltsCourseLessonResponse!.lessonContent
              .toString()),
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
            Fluttertoast.showToast(msg: video.lessonId.toString());
          },
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 5.0),
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: AppColors.vocabularyCatCardColor,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Text(
              video.videoTitle,
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }
}
