import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:markdown_widget/widget/markdown.dart';
import 'package:provider/provider.dart';
import 'package:risho_speech/screens/IeltsListeningExamScreen.dart';
import 'package:risho_speech/utils/device/device_utility.dart';

import '../../providers/auth_provider.dart';
import '../../providers/ieltsListeningExamQuestionProvider.dart';
import '../../ui/colors.dart';

class InstructionIeltsListeningScreenMobile extends StatefulWidget {
  const InstructionIeltsListeningScreenMobile({super.key});

  @override
  State<InstructionIeltsListeningScreenMobile> createState() =>
      _InstructionIeltsListeningScreenMobileState();
}

class _InstructionIeltsListeningScreenMobileState
    extends State<InstructionIeltsListeningScreenMobile> {
  String listeningOverview = """
## **IELTS Listening Test Instructions**

### **1. Overview of the Listening Test**
- **Total Duration:** 30 minutes (plus 10 minutes for transferring answers to the answer sheet).
- **Number of Sections:** 4 sections with a total of 40 questions.
- **Audio:** Each section features a different audio recording (conversation, monologue, or discussion).
- **Question Types:** Multiple choice, matching, plan/map/diagram labeling, form/note/table/flow-chart/summary completion, sentence completion.

### **2. Test Format**
- **Section 1:** A conversation between two people set in an everyday social context (e.g., booking a hotel room).
- **Section 2:** A monologue set in an everyday social context (e.g., a speech about local facilities).
- **Section 3:** A conversation among up to four people set in an educational or training context (e.g., a group of students discussing an assignment).
- **Section 4:** A monologue on an academic subject (e.g., a lecture).

### **3. Listening Test Instructions**

#### **Before the Test Begins**
1. **Check Your Equipment:** Ensure your headphones are working properly. Adjust the volume to a comfortable level.
2. **Read the Instructions:** Carefully read the instructions and examples provided at the beginning of each section.
3. **Familiarize with the Layout:** Understand the layout of the answer sheet and how to record your answers.

#### **During the Test**
1. **Listen to the Instructions:** Listen to the test conductor’s instructions and the introduction to each section.
2. **Focus:** Stay focused and listen attentively as each recording is played only once.
3. **Follow the Order:** Answer the questions in the order they appear. The questions will follow the order of the information presented in the recording.
4. **Use the Time Provided:** After each section, you will have time to review your answers. Utilize this time to check your answers and ensure clarity.
5. **Note-Taking:** Use the question booklet to jot down notes or highlight important points while listening. Write legibly as you will need to transfer your answers to the answer sheet.
6. **Check Your Answers:** As you listen, write your answers directly in the question booklet. You will have 10 minutes at the end of the test to transfer these answers to the answer sheet.

#### **After the Listening Test**
1. **Transfer Answers:** You will be given 10 minutes to transfer your answers from the question booklet to the answer sheet.
2. **Be Accurate:** Ensure your spelling and grammar are correct as they will impact your score.
3. **Use the Correct Answer Sheet:** Make sure you are writing on the listening answer sheet, not the reading one.
4. **Check Your Details:** Ensure you have filled in all required details on the answer sheet, such as your name and candidate number.

### **4. Scoring and Tips**
- **Each correct answer** receives 1 mark. The total score out of 40 will determine your band score.
- **Band Scores:** Scores are reported in whole and half bands (e.g., 6.0, 6.5, 7.0).
- **Answer All Questions:** There’s no penalty for wrong answers, so attempt all questions.
- **Practice:** Familiarize yourself with different accents and speeds of speech. Practice with sample tests to improve your listening skills.

# Good Luck!
""";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Practice Listening",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: MarkdownWidget(
                  data: listeningOverview,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const IeltsListeningExamScreen()),
                );
              },
              child: Container(
                width: double.infinity,
                color: AppColors.primaryColor2,
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  "Start Practicing",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
