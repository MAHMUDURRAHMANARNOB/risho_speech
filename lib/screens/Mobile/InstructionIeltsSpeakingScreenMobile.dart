import 'package:flutter/material.dart';
import 'package:markdown_widget/widget/markdown.dart';
import 'package:risho_speech/screens/IeltsSpeakingExamScreen.dart';

import '../../ui/colors.dart';

class InstructionIeltsSpeakingScreenMobile extends StatefulWidget {
  const InstructionIeltsSpeakingScreenMobile({super.key});

  @override
  State<InstructionIeltsSpeakingScreenMobile> createState() =>
      _InstructionIeltsSpeakingScreenMobileState();
}

class _InstructionIeltsSpeakingScreenMobileState
    extends State<InstructionIeltsSpeakingScreenMobile> {
  String speakingOverview = """
## **IELTS Speaking Test Instructions**

### **1. Overview of the Speaking Test**
- **Total Duration:** 11–14 minutes.
- **Format:** Face-to-face interview with a certified examiner.
- **Sections:** The test is divided into 3 parts, each designed to assess different aspects of your speaking ability.

### **2. Test Format**
- **Part 1: Introduction and Interview (4–5 minutes)**
  - **Focus:** General questions about yourself, your home, family, work, studies, and interests.
  - **Example Topics:** Hobbies, travel, daily routine, etc.
- **Part 2: Long Turn (3–4 minutes)**
  - **Focus:** A monologue where you will speak on a given topic for 1-2 minutes.
  - **Preparation Time:** 1 minute to prepare your thoughts and notes before speaking.
  - **Example Task:** Describe a memorable event, a favorite book, a place you have visited, etc.
- **Part 3: Discussion (4–5 minutes)**
  - **Focus:** A two-way discussion where the examiner will ask more in-depth questions related to the Part 2 topic.
  - **Example Topics:** Analyzing broader themes, exploring abstract ideas, and discussing opinions on societal issues.

### **3. Speaking Test Instructions**

#### **Before the Test Begins**
1. **Preparation:** Review common topics and practice speaking English regularly before the test.
2. **Identification:** Bring a valid ID, as you will need to verify your identity before the test begins.
3. **Relax:** Stay calm and confident. The test is a conversation, not an interrogation.

#### **During the Test**

##### **Part 1: Introduction and Interview**
1. **Introduction:** The examiner will introduce themselves and ask you to confirm your identity.
2. **General Questions:** Answer simple, everyday questions about yourself. Keep your answers clear and concise.
3. **Be Natural:** Speak naturally and don’t memorize answers. The examiner is assessing your ability to communicate effectively.

##### **Part 2: Long Turn**
1. **Topic Card:** The examiner will give you a task card with a topic and some points to cover.
2. **Preparation Time:** You have 1 minute to prepare. Use this time to jot down key points or ideas.
3. **Speak Continuously:** You are expected to speak for 1-2 minutes. Make sure you cover all points on the card.
4. **Structure Your Response:** Begin with an introduction, then cover each point, and conclude with a summary or personal opinion.
5. **Maintain Fluency:** Focus on fluency and coherence rather than perfection. If you make a mistake, continue speaking without getting flustered.

##### **Part 3: Discussion**
1. **In-depth Discussion:** The examiner will ask questions that relate to the topic from Part 2, often exploring broader issues or abstract ideas.
2. **Provide Detailed Answers:** Give detailed and extended answers, expressing your opinions and supporting them with examples.
3. **Engage in the Discussion:** Treat this part as a conversation. It’s important to demonstrate your ability to discuss and analyze topics.
4. **Clarify if Needed:** If you don’t understand a question, politely ask the examiner to repeat or clarify.

#### **After the Speaking Test**
1. **Stay Calm:** After finishing, stay calm and wait for the examiner to conclude the test.
2. **Review:** Reflect on your performance and note areas for improvement, especially if you plan to retake the test.

### **4. Scoring and Tips**
- **Assessment Criteria:** The examiner will assess you on four criteria:
  - **Fluency and Coherence:** Ability to speak smoothly and logically.
  - **Lexical Resource:** Range and accuracy of vocabulary.
  - **Grammatical Range and Accuracy:** Use of correct grammar structures.
  - **Pronunciation:** Clarity and naturalness of your pronunciation.
- **Speak Clearly:** Pronunciation is important; speak clearly to ensure the examiner understands you.
- **Practice Speaking:** Engage in regular speaking practice with native speakers or through practice tests.
- **Be Yourself:** The speaking test is about your ability to communicate effectively in English. Be yourself and communicate naturally.

# Good Luck!
""";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Practice Speaking",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: MarkdownWidget(
                    data: speakingOverview,
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                color: AppColors.primaryColor2,
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const IeltsSpeakingExamScreen()),
                    );
                  },
                  child: const Text(
                    "Start Practicing",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
