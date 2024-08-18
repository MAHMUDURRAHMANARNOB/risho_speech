import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:siri_wave/siri_wave.dart';

class AudioVisualizer extends StatefulWidget {
  final AudioPlayer audioPlayer;
  final bool isRecording;

  const AudioVisualizer({
    required this.audioPlayer,
    required this.isRecording,
    Key? key,
  }) : super(key: key);

  @override
  _AudioVisualizerState createState() => _AudioVisualizerState();
}

class _AudioVisualizerState extends State<AudioVisualizer> {
  late bool _isPlaying;
  late IOS9SiriWaveformController _siriWaveController;
  Timer? _waveformTimer;

  @override
  void initState() {
    super.initState();
    _isPlaying = false;

    _siriWaveController = IOS9SiriWaveformController(
      amplitude: 0.5,
      speed: 0.15,
    );

    widget.audioPlayer.playbackEventStream.listen((event) {
      setState(() {
        _isPlaying = widget.audioPlayer.playing;
      });
    });

    widget.audioPlayer.playerStateStream.listen((state) {
      setState(() {
        _isPlaying = widget.audioPlayer.playing;
      });
    });
    _startWaveformUpdate();
  }

  void _startWaveformUpdate() {
    _waveformTimer?.cancel(); // Cancel any existing timer
    _waveformTimer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      if (widget.audioPlayer.playing) {
        // Update SiriWaveformController with current playback position
        _siriWaveController.amplitude =
            widget.audioPlayer.position.inMilliseconds % 1000 / 1000;
      } else {
        _siriWaveController.amplitude = 0; // Stop animation when not playing
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          width: double.infinity,
          height: 200,
          child: !_isPlaying || !widget.isRecording
              ? SiriWaveform.ios9(
                  controller: _siriWaveController,
                  options: IOS9SiriWaveformOptions(
                    height: 200,
                    width: double.infinity - 60,
                    showSupportBar: true,
                  ),
                )
              : SiriWaveform.ios9(
                  controller: _siriWaveController,
                  options: IOS9SiriWaveformOptions(
                    height: 180,
                    width: double.infinity - 60,
                  ),
                )),
    );
  }
}

class StraightLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final path = Path();
    path.moveTo(0, size.height / 2);
    path.lineTo(size.width, size.height / 2);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
