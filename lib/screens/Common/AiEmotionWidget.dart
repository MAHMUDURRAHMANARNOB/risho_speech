import 'package:flutter/material.dart';

class AiEmotionWidget extends StatelessWidget {
  final bool isAiSaying;
  final bool isAiAnalyzing;
  final bool isAiListening;
  final bool isAiWaiting;
  final String AIName;

  AiEmotionWidget({
    required this.isAiSaying,
    required this.isAiAnalyzing,
    required this.isAiListening,
    required this.isAiWaiting,
    required this.AIName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (isAiSaying)
          _buildEmotionWidget(
            image: AssetImage('assets/images/saying.png'),
            text: '$AIName is Saying',
          )
        else if (isAiAnalyzing)
          _buildEmotionWidget(
            image: AssetImage('assets/images/thinking.png'),
            text: '$AIName is Thinking',
          )
        else if (isAiListening)
          _buildEmotionWidget(
            image: AssetImage('assets/images/listening.png'),
            text: '$AIName is Listening',
          )
        else if (isAiWaiting)
          _buildEmotionWidget(
            image: AssetImage('assets/images/waiting.png'),
            text: 'Waiting for your response',
          )
        else
          _buildEmotionWidget(
            image: AssetImage('assets/images/waiting.png'),
            text: 'Waiting for your response',
          )
      ],
    );
  }

  Widget _buildEmotionWidget({
    required ImageProvider<Object> image,
    required String text,
  }) {
    return Column(
      children: [
        Image(
          image: image,
          height: 100,
          width: 100,
        ),
        SizedBox(height: 8),
        Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
