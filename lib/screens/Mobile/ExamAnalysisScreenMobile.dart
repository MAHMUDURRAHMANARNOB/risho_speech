import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:risho_speech/screens/dashboard.dart';
import 'package:risho_speech/ui/colors.dart';

import '../../models/listeningPracticeBandScoreDataModel.dart';

class ExamAnalysisScreenMobile extends StatefulWidget {
  final Map<String, dynamic> listeningData;

  const ExamAnalysisScreenMobile({super.key, required this.listeningData});

  @override
  State<ExamAnalysisScreenMobile> createState() =>
      _ExamAnalysisScreenMobileState();
}

class _ExamAnalysisScreenMobileState extends State<ExamAnalysisScreenMobile> {
  late ListeningPracticeBandScoreDataModel listeningPracticeBandScoreDataModel;

  @override
  void initState() {
    super.initState();
    // Parse the JSON string into the data model
    // Map<String, dynamic> jsonResponse = jsonDecode(widget.listeningData);
    listeningPracticeBandScoreDataModel =
        ListeningPracticeBandScoreDataModel.fromJson(widget.listeningData);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop:
          // Custom logic before popping the screen
          // Returning true allows the back navigation
          true,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Exam Analysis',
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Score: ${listeningPracticeBandScoreDataModel.score}',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  'IELTS Band: ${listeningPracticeBandScoreDataModel.ieltsBand}',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount:
                        listeningPracticeBandScoreDataModel.ansReview.length,
                    itemBuilder: (context, index) {
                      final answer =
                          listeningPracticeBandScoreDataModel.ansReview[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppColors.primaryColor2,
                            child: Text(
                              '${answer.questionNo}',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          title: Text('Correct Answer: ${answer.correctAns}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Your Answer: ${answer.givenAns}'),
                              Text(
                                'Is Correct: ${answer.isCorrect ? "Yes" : "No"}',
                                style: TextStyle(
                                  color: answer.isCorrect
                                      ? Colors.green
                                      : Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor2),
                    onPressed: () {
                      // Navigate to the dashboard (or any other page)
                      // Navigator.pushAndRemoveUntil(Dashboard());
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Dashboard()),
                        /*(Route<dynamic> route) =>
                            false, */ // This condition will remove all previous routes
                        // This condition will remove all previous routes
                      );
                    },
                    child: Text(
                      'Go to Dashboard',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
