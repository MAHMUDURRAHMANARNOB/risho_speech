import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:iconsax/iconsax.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:markdown_widget/config/configs.dart';
import 'package:markdown_widget/widget/markdown.dart';
import 'package:provider/provider.dart';
import 'package:risho_speech/providers/ShonodAiResponseProvider.dart';
import 'package:risho_speech/providers/auth_provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../ui/colors.dart';
import '../Common/error_dialog.dart';
import '../packages_screen.dart';

class IeltsAssistantScreenMobile extends StatefulWidget {
  const IeltsAssistantScreenMobile({super.key});

  @override
  State<IeltsAssistantScreenMobile> createState() =>
      _IeltsAssistantScreenMobileState();
}

class _IeltsAssistantScreenMobileState
    extends State<IeltsAssistantScreenMobile> {
  List<Widget> _lessonComponents = [];
  TextEditingController questionTextFieldController = TextEditingController();
  late ShonodAiResponseProvider shonodAiResponseProvider;
  final ScrollController _scrollController = ScrollController();
  bool _showScrollToBottomButton = false;

  @override
  void initState() {
    // TODO: implement initState
    shonodAiResponseProvider = ShonodAiResponseProvider();

    _scrollController.addListener(() {
      // Show the button if the user scrolls up from the bottom
      if (_scrollController.hasClients) {
        final offset = _scrollController.offset;
        final maxScrollExtent = _scrollController.position.maxScrollExtent;

        setState(() {
          _showScrollToBottomButton =
              offset < maxScrollExtent; // Adjust the threshold as needed
        });
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  late String? _sessionId = null;
  late String _question = '';

  @override
  Widget build(BuildContext context) {
    int userId = Provider.of<AuthProvider>(context).user!.id ?? 2;
    /* shonodAiResponseProvider =
        Provider.of<ShonodAiResponseProvider>(context, listen: false);*/
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "IELTS Assistant",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    physics: BouncingScrollPhysics(),
                    child: _lessonComponents.isNotEmpty
                        ? Column(
                            children: _lessonComponents,
                          )
                        : Container(
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
                // color: AppColors.primaryColor.withOpacity(0.1),
                margin: const EdgeInsets.only(
                    left: 10.0, right: 10.0, bottom: 15.0, top: 8.0),
                /*decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: )
            ),*/
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: questionTextFieldController,
                        maxLines: 3,
                        minLines: 1,
                        cursorColor: AppColors.primaryColor,
                        decoration: InputDecoration(
                          hintText: 'Ask your question...',
                          hintStyle: const TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.w600),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0)),
                            borderSide: BorderSide(
                                color: AppColors.secondaryCardColorGreenish
                                    .withOpacity(0.5)), // Transparent border
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0)),
                            borderSide: BorderSide(
                              color: AppColors.secondaryCardColorGreenish
                                  .withOpacity(0.5),
                            ),
                          ),
                          fillColor: AppColors.secondaryCardColorGreenish
                              .withOpacity(0.5),
                          filled: true,
                        ),
                        onChanged: (value) {
                          _question = value;
                        },
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (_question.isNotEmpty) {
                          questionTextFieldController.clear();
                          setState(() {
                            _lessonComponents.add(
                              generateComponentGettingResponse(
                                "Ielts Preparation expert",
                                _question,
                                "N",
                                "Bangladesh",
                                userId,
                                _sessionId,
                              ),
                            );
                          });
                        } else {
                          ErrorDialog(
                            message: "Ask Your Question First",
                          );
                        }
                      },
                      icon: const Icon(
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
          if (_showScrollToBottomButton)
            Positioned(
              bottom: 90,
              right: 20,
              child: FloatingActionButton(
                backgroundColor: Colors.white,
                onPressed: () {
                  /*_scrollController.animateTo(
                    _scrollController.position.maxScrollExtent,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );*/
                  _scrollToBottom();
                },
                child: Icon(
                  Icons.arrow_downward,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _scrollToBottom() {
    setState(() {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  Widget generateComponentGettingResponse(
      String professiontitle,
      String QuestionText,
      String isBangla,
      String contextArea,
      int userid,
      String? sessionID) {
    bool _isPressed = false;

    return FutureBuilder<void>(
      future: shonodAiResponseProvider.fetchShonodAiResponse(professiontitle,
          QuestionText, isBangla, contextArea, userid, sessionID),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          /*return const SpinKitThreeInOut(
            color: AppColors.primaryColor,
          ); */
          return Container(
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 5.0),
                  child: Image.asset(
                    "assets/images/risho_guru_icon.png",
                    height: 30,
                    width: 30,
                  ),
                ),
                SizedBox(
                  child: Shimmer.fromColors(
                    baseColor: AppColors.primaryColor,
                    highlightColor: Colors.white,
                    child: const Text(
                      'Preparing...',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Container(
            margin: const EdgeInsets.all(5.0),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: AppColors.primaryCardColor,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    "Sorry: ${shonodAiResponseProvider.spokenLessonListResponse?.message ?? "Server error"}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if (shonodAiResponseProvider.spokenLessonListResponse == null) {
          return ErrorDialog(
            message: "No response received from the server.",
          );
        } else {
          final response = shonodAiResponseProvider.spokenLessonListResponse!;
          if (response.errorCode == 200) {
            final lessonAnswer = response.answer;
            _sessionId = response.sessionID!;
            /*final lessonAnswer =
            utf8.decode(lessonAnswerEncoded!.runes.toList());*/

            // final ticketId = response.ticketId!;
            return _buildResponseWidget(QuestionText, lessonAnswer);
          } else if (response.errorCode == 201) {
            return Container(
              margin: const EdgeInsets.all(5.0),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: AppColors.primaryCardColor,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      "Sorry: ${shonodAiResponseProvider.spokenLessonListResponse!.message}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryCardColor),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PackagesScreen()),
                        );
                      },
                      child: const Text(
                        "Purchase Minutes",
                        style: TextStyle(
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
            // return Text("${response.message}");
          } else {
            return _buildErrorWidget(message: response!.message);
          }
        }
      },
    );
  }

  Widget _buildResponseWidget(String questionText, String? lessonAnswer) {
    return Container(
      margin: const EdgeInsets.all(5.0),
      padding: const EdgeInsets.all(8.0),
      /*decoration: BoxDecoration(
        color: AppColors.primaryCardColor,
        borderRadius: BorderRadius.circular(10.0),
      ),*/
      /*decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        // border: Border.all(width: 1.0, color: AppColors.primaryColor),
        color: */ /*AppColors.primaryColor2.withOpacity(
                                    0.3) */ /*
            AppColors.backgroundColorDark,
      ),*/
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            child: Text(
              "Q: ${questionText}",
              softWrap: true,
              style: TextStyle(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
          ),
          Container(
            width: double.infinity,
            // margin: const EdgeInsets.all(5.0),
            // padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: AppColors.backgroundColorDark,
              borderRadius: BorderRadius.circular(10.0),
            ),
            /*decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Colors.transparent,
                  // Start with a transparent color
                  AppColors.primaryColor2.withOpacity(0.1),
                  // Adjust opacity as needed
                ],
              ),
              border: Border.all(
                color: AppColors.primaryColor,
                width: 0.2,
              ),
            ),*/
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: MarkdownWidget(
                data: lessonAnswer ?? "No content available",
                shrinkWrap: true,
                selectable: true,
                config: MarkdownConfig.defaultConfig,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget({String? message}) {
    return Container(
      margin: const EdgeInsets.all(5.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              "Sorry: ${message ?? "An error occurred"}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryCardColor,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PackagesScreen(),
                  ),
                );
              },
              child: const Text(
                "Buy Subscription",
                style: TextStyle(
                  color: AppColors.primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
