import 'package:flutter/material.dart';

class VideoPlayerBoardScreenTablet extends StatefulWidget {
  final String videoUrl;
  final String videoTitle;
  final String isVideo;
  final String lessonContentId;

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
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
