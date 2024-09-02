import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import '../../ui/colors.dart';

class IeltsAssistantScreenMobile extends StatefulWidget {
  const IeltsAssistantScreenMobile({super.key});

  @override
  State<IeltsAssistantScreenMobile> createState() =>
      _IeltsAssistantScreenMobileState();
}

class _IeltsAssistantScreenMobileState
    extends State<IeltsAssistantScreenMobile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "IELTS Assistant",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              child: SingleChildScrollView(
                // controller: _scrollController,
                physics: BouncingScrollPhysics(),
                child: /* _lessonComponents.isNotEmpty
                    ? Column(
                  children: _lessonComponents,
                )
                    : */
                    Container(
                  decoration: BoxDecoration(
                    color: AppColors.primaryCardColor,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  margin: EdgeInsets.all(8),
                  padding: EdgeInsets.all(16),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Welcome to IELTS ASSISTANT',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            textAlign: TextAlign.center,
                            'Ask anything as you are speaking to a Ielts Trainer',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    // controller: questionTextFieldController,
                    maxLines: 3,
                    minLines: 1,
                    cursorColor: AppColors.primaryColor,
                    decoration: const InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(50.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(40.0)),
                        borderSide: BorderSide(
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      // inputText = value;
                    },
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    IconsaxPlusBold.direct_right,
                    color: AppColors.primaryColor,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
