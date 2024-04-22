import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:risho_speech/ui/colors.dart';

import '../../providers/auth_provider.dart';

class PronunciationScreenMobile extends StatefulWidget {
  final int conversationId;
  final int dialogId;
  final String conversationEn;
  final String conversationBn;
  final String conversationAudioFile;
  final int seqNumber;
  final String conversationDetails;
  final String discussionTopic;
  final String discusTitle;
  final String actorName;
  const PronunciationScreenMobile({
    super.key,
    required this.conversationId,
    required this.dialogId,
    required this.conversationEn,
    required this.conversationBn,
    required this.conversationAudioFile,
    required this.seqNumber,
    required this.conversationDetails,
    required this.discussionTopic,
    required this.discusTitle,
    required this.actorName,
  });

  @override
  State<PronunciationScreenMobile> createState() =>
      _PronunciationScreenMobileState();
}

class _PronunciationScreenMobileState extends State<PronunciationScreenMobile> {
  TextEditingController _askQuescontroller = TextEditingController();

  void _textChangeListener() {
    // setState(() {
    //   _isTextQuestion = _askQuescontroller.text.isNotEmpty;
    // });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _askQuescontroller.addListener(_textChangeListener);
  }

  @override
  void dispose() {
    _askQuescontroller.removeListener(_textChangeListener);
    _askQuescontroller.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final username =
        Provider.of<AuthProvider>(context).user?.name ?? 'UserName';
    final userId = Provider.of<AuthProvider>(context).user?.id ?? 123;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryCardColor,
        title: Text(
          widget.discusTitle,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          /*Top*/
          Expanded(
            child: Container(
              width: double.infinity,
              // color: AppColors.greyCard.withOpacity(0.1),
              child: Text("123"),
            ),
          ),
          /*BottomControl*/
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.primaryCardColor,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(80),
                topLeft: Radius.circular(80),
              ),
            ),
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: [
                /* SEND / VOICE */
                IconButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.backgroundColorDark,
                      elevation: 4,
                    ),
                    onPressed: () {
                      // Add your logic to send the message
                      setState(() {});
                    },
                    icon: Container(
                      padding: EdgeInsets.all(15),
                      child: Icon(
                        Icons.mic,
                        color: AppColors.primaryColor,
                        size: 24,
                      ),
                    )),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                  ),
                  onPressed: () {},
                  child: Text(
                    "Next",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      // bottomSheet: BottomSection(),
    );
  }
}
