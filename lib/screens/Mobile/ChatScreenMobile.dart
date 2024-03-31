import 'package:flutter/material.dart';
import 'package:risho_speech/ui/colors.dart';

class ChatScreenMobile extends StatefulWidget {
  const ChatScreenMobile({super.key});

  @override
  State<ChatScreenMobile> createState() => _ChatScreenMobileState();
}

class _ChatScreenMobileState extends State<ChatScreenMobile> {
  TextEditingController _askQuescontroller = TextEditingController();
  bool _isTextQuestion = false;

  @override
  void initState() {
    super.initState();
    _askQuescontroller.addListener(_textChangeListener);
  }

  @override
  void dispose() {
    _askQuescontroller.removeListener(_textChangeListener);
    _askQuescontroller.dispose();
    super.dispose();
  }

  void _textChangeListener() {
    setState(() {
      _isTextQuestion = _askQuescontroller.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Risho"),
        actions: [
          IconButton(
            icon: const Icon(Icons.mark_unread_chat_alt_outlined),
            tooltip: 'Show Snackbar',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('This is a snackbar')));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          /*top*/
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(5.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 7,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              color: AppColors.primaryColor.withOpacity(0.3),
                            ),
                            padding: EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                Image.asset(
                                  "assets/images/risho_guru_icon.png",
                                  height: 30,
                                  width: 30,
                                ),
                                const SizedBox(
                                  width: 5.0,
                                ),
                                const Text("Text From the AI"),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Container(),
                        ),
                        Expanded(
                          flex: 7,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              color: AppColors.secondaryColor.withOpacity(0.3),
                            ),
                            padding: EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const Text(
                                  "Text From the user",
                                  style: TextStyle(
                                      overflow: TextOverflow.ellipsis),
                                ),
                                const SizedBox(
                                  width: 5.0,
                                ),
                                Image.asset(
                                  "assets/images/profile_chat.png",
                                  height: 30,
                                  width: 30,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          /*Bottom control*/
          Container(
            margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.backgroundColorDark),
                  onPressed: () {
                    // Add your logic to send the message
                  },
                  child: Text(
                    "New Question",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.backgroundColorDark),
                  onPressed: () {
                    // Add your logic to send the message
                  },
                  child: Text(
                    "Suggest Answer",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: AppColors.backgroundColorDark,
            padding: const EdgeInsets.all(5.0),
            child: Row(
              children: [
                /*SPEAKER*/
                IconButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.backgroundColorDark),
                  onPressed: () {
                    /* _pickImage(context);*/
                  },
                  icon: const Icon(
                    Icons.volume_up_rounded,
                    color: AppColors.primaryColor,
                    size: 18,
                  ),
                ),
                /*Question Asking*/
                Expanded(
                  child: TextField(
                    controller: _askQuescontroller,
                    maxLines: 3,
                    minLines: 1,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                    cursorColor: AppColors.primaryColor,
                    decoration: const InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.primaryColor,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 10.0),
                    ),
                    onChanged: (value) {
                      // inputText = value;
                      setState(() {
                        _isTextQuestion = value.isNotEmpty;
                      });
                    },
                  ),
                ),
                /*SEND / VOICE*/
                IconButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.backgroundColorDark),
                  onPressed: () {
                    // Add your logic to send the message
                    /*setState(() {
                      _lessonComponents.add(generateComponent(
                          userid,
                          inputText,
                          selectedCourseId,
                          _selectedLessonIndex,
                          selectedLessonId));
                    });*/
                  },
                  icon: _isTextQuestion == true
                      ? Icon(
                          Icons.send_rounded,
                          color: AppColors.primaryColor,
                          size: 18,
                        )
                      : Icon(
                          Icons.keyboard_voice_rounded,
                          color: AppColors.primaryColor,
                          size: 18,
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
