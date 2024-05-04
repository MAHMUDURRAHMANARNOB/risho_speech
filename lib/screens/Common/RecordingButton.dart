import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';

import '../../ui/colors.dart';

class RecordingButton extends StatefulWidget {
  final Function onStartRecording;
  final Function onStopRecording;
  final bool isRecording;

  const RecordingButton({
    required this.onStartRecording,
    required this.onStopRecording,
    required this.isRecording,
  });

  @override
  _RecordingButtonState createState() => _RecordingButtonState();
}

class _RecordingButtonState extends State<RecordingButton> {
  @override
  Widget build(BuildContext context) {
    return AvatarGlow(
      animate: widget.isRecording,
      curve: Curves.fastOutSlowIn,
      glowColor: AppColors.primaryColor,
      duration: const Duration(milliseconds: 1000),
      repeat: true,
      glowRadiusFactor: 1,
      child: Container(
        margin: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
        child: IconButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.isRecording == false
                ? Colors.white
                : AppColors.primaryColor,
            elevation: 4,
          ),
          onPressed: () async {
            // Add your logic to send the message
            if (!widget.isRecording) {
              await widget.onStartRecording();
            } else {
              await widget.onStopRecording();
            }
          },
          icon: Container(
            padding: const EdgeInsets.all(20),
            child: Icon(
              widget.isRecording == false
                  ? Icons.keyboard_voice_rounded
                  : Icons.stop_rounded,
              color: widget.isRecording == false
                  ? AppColors.primaryColor
                  : Colors.white,
              size: 30,
            ),
          ),
        ),
      ),
    );
  }
}
