import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../ui/colors.dart';

class AiEmotionWidget extends StatelessWidget {
  final bool isAiSaying;
  final bool isAiAnalyzing;
  final bool isAiListening;
  final bool isAiWaiting;
  final String AIName;
  final String AIGander;

  AiEmotionWidget({
    required this.isAiSaying,
    required this.isAiAnalyzing,
    required this.isAiListening,
    required this.isAiWaiting,
    required this.AIName,
    required this.AIGander,
  });

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    String gander = '';
    if (AIGander == "M") {
      gander = "assets/images/man_Caller/";
    } else {
      gander = "assets/images/woman_Caller/";
    }
    return Column(
      children: [
        if (isAiSaying)
          _buildEmotionWidget(
            image: AssetImage("${gander}saying.png"),
            text: '$AIName is Saying',
            screenHeight: screenHeight,
            screenWidth: screenWidth,
            highlightColor: AppColors.secondaryColor,
          )
        else if (isAiAnalyzing)
          _buildEmotionWidget(
            image: AssetImage('${gander}thinking.png'),
            text: '$AIName is Preparing',
            screenHeight: screenHeight,
            screenWidth: screenWidth,
            highlightColor: AppColors.primaryColor,
          )
        else if (isAiListening)
          _buildEmotionWidget(
            image: AssetImage('${gander}listening.png'),
            text: '$AIName is Listening',
            screenHeight: screenHeight,
            screenWidth: screenWidth,
            highlightColor: AppColors.primaryContainerColor,
          )
        else if (isAiWaiting)
          _buildEmotionWidget(
            image: AssetImage('${gander}waiting.png'),
            text: 'Waiting for your response',
            screenHeight: screenHeight,
            screenWidth: screenWidth,
            highlightColor: Colors.white,
          )
        else
          _buildEmotionWidget(
            image: AssetImage('${gander}waiting.png'),
            text: 'Waiting for your response',
            screenHeight: screenHeight,
            screenWidth: screenWidth,
            highlightColor: Colors.white,
          )
      ],
    );
  }

  Widget _buildEmotionWidget({
    required ImageProvider<Object> image,
    required String text,
    required double screenHeight,
    required double screenWidth,
    required Color highlightColor,
  }) {
    return Column(
      children: [
        Image(
          image: image,
          height: screenHeight * 0.2, // Adjusted height based on screen height
          width: screenWidth * 0.35,
        ),
        Shimmer.fromColors(
          baseColor: Colors.white,
          highlightColor: highlightColor,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        /*Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: screenHeight * 0.025,
          ),
        ),*/
      ],
    );
  }
}
