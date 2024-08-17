import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:risho_speech/ui/colors.dart';

class IeltsSpeakingExamScreenMobile extends StatefulWidget {
  const IeltsSpeakingExamScreenMobile({super.key});

  @override
  State<IeltsSpeakingExamScreenMobile> createState() =>
      _IeltsSpeakingExamScreenMobileState();
}

class _IeltsSpeakingExamScreenMobileState
    extends State<IeltsSpeakingExamScreenMobile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "IELTS Speaking Test",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Stage Determiner
            Text(
              "Stage - 1",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20.0),
            // Cue Card Topic -- Only visible for stage 2
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.0),
                color: AppColors.vocabularyCatCardColor,
              ),
              child: Column(
                children: [
                  Text(
                    "Cue Card Topic",
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    "Describe a time when you were really proud of yourself.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            // Microphone button for telling
            IconButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor),
              onPressed: () {},
              icon: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Icon(
                  Iconsax.microphone,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 20.0),
            //   Cancel Test
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 15,
                ),
              ),
              onPressed: () {},
              child: Text(
                "Cancel Test",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
