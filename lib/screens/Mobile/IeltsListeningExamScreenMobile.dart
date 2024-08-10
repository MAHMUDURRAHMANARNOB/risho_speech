import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:just_audio/just_audio.dart';

class IeltsListeningExamScreenMobile extends StatefulWidget {
  const IeltsListeningExamScreenMobile({super.key});

  @override
  State<IeltsListeningExamScreenMobile> createState() =>
      _IeltsListeningExamScreenMobileState();
}

class _IeltsListeningExamScreenMobileState
    extends State<IeltsListeningExamScreenMobile> {
  final player = AudioPlayer();

  String formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60);
    final seconds = d.inSeconds.remainder(60);
    return "${minutes.toString().padLeft(2, '0')} : ${seconds.toString().padLeft(2, '0')}";
  }

  void handlePlayPause() {
    if (player.playing) {
      player.pause();
    } else {
      player.play();
    }
  }

  void handleSeek(double value) {
    player.seek(Duration(seconds: value.toInt()));
  }

  Duration position = Duration.zero;
  Duration duration = Duration.zero;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    player.setUrl(
        "https://rishoguru.sgp1.cdn.digitaloceanspaces.com/ielts/listening/listening_3.1.wav");

    //   Listen to the position updates
    player.positionStream.listen((p) {
      setState(() {
        position = p;
      });
    });

    player.durationStream.listen((d) {
      setState(() {
        duration = d!;
      });
    });
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("IELTS Listening Test"),
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            //   Audio place
            Text(formatDuration(position)),
            Slider(
              min: 0.0,
              max: duration.inSeconds.toDouble(),
              value: position.inSeconds
                  .toDouble()
                  .clamp(0.0, duration.inSeconds.toDouble()),
              onChanged: handleSeek,
            ),
            Text(formatDuration(duration)),
            IconButton(
              onPressed: handlePlayPause,
              icon: player.playing ? Icon(Iconsax.pause) : Icon(Iconsax.play),
            ),
            //   Question and Answer Tab

            //   at the very bottom Submit button to call next section
          ],
        ),
      ),
    );
  }
}
