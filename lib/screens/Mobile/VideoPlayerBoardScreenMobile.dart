import 'package:flutter/material.dart';
import 'package:risho_speech/ui/colors.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerBoardScreenMobile extends StatefulWidget {
  final String videoUrl;
  final String videoTitle;
  final String isVideo;
  final String lessonContentId;

  const VideoPlayerBoardScreenMobile(
      {super.key,
      required this.videoUrl,
      required this.videoTitle,
      required this.isVideo,
      required this.lessonContentId});

  @override
  State<VideoPlayerBoardScreenMobile> createState() =>
      _VideoPlayerBoardScreenMobileState();
}

class _VideoPlayerBoardScreenMobileState
    extends State<VideoPlayerBoardScreenMobile> {
  late YoutubePlayerController _controller;
  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;
  double _volume = 100;
  bool _muted = false;
  bool _isPlayerReady = false;

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

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Column(
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
    );
  }
}
