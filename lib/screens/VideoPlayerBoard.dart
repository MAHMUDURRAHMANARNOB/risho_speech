import 'package:flutter/material.dart';
import 'package:risho_speech/screens/tablet/VideoPlayerBoardScreenTablet.dart';

import '../responsive/responsive_layout.dart';
import 'Mobile/VideoPlayerBoardScreenMobile.dart';

class VideoPlayerBoard extends StatefulWidget {
  final String videoUrl;
  final String videoTitle;
  final String isVideo;
  final int lessonContentId;

  const VideoPlayerBoard(
      {super.key,
      required this.videoUrl,
      required this.videoTitle,
      required this.isVideo,
      required this.lessonContentId});

  @override
  State<VideoPlayerBoard> createState() => _VideoPlayerBoardState();
}

class _VideoPlayerBoardState extends State<VideoPlayerBoard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileScaffold: VideoPlayerBoardScreenMobile(
          videoUrl: widget.videoUrl,
          videoTitle: widget.videoTitle,
          isVideo: widget.isVideo,
          lessonContentId: widget.lessonContentId,
        ),
        tabletScaffold: VideoPlayerBoardScreenMobile(
          videoUrl: widget.videoUrl,
          videoTitle: widget.videoTitle,
          isVideo: widget.isVideo,
          lessonContentId: widget.lessonContentId,
        ),
        desktopScaffold: VideoPlayerBoardScreenTablet(
          videoUrl: widget.videoUrl,
          videoTitle: widget.videoTitle,
          isVideo: widget.isVideo,
          lessonContentId: widget.lessonContentId.toString(),
        ),
      ),
    );
  }
}
