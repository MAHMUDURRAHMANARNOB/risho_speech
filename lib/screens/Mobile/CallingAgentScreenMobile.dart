import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:risho_speech/providers/callAndConversationProvider.dart';
import 'package:risho_speech/screens/CallingScreen.dart';
import 'package:risho_speech/ui/colors.dart';

import '../../providers/auth_provider.dart';
import '../../providers/calling_agentProvider.dart';

class CallingAgentScreenMobile extends StatefulWidget {
  const CallingAgentScreenMobile({super.key});

  @override
  State<CallingAgentScreenMobile> createState() =>
      _CallingAgentScreenMobileState();
}

class _CallingAgentScreenMobileState extends State<CallingAgentScreenMobile> {
  CallingAgentListProvider callingAgentListProvider =
      CallingAgentListProvider();

  @override
  void initState() {
    super.initState();
    callingAgentListProvider.fetchCallingAgentListResponse();
  }

  final CallConversationProvider callConversationProvider =
      CallConversationProvider();

  @override
  Widget build(BuildContext context) {
    String? sessionId;
    String? agentAudio;
    String? aiDialog;
    String? aiDialogBn;

    final username =
        Provider.of<AuthProvider>(context).user?.name ?? 'UserName';
    final userId = Provider.of<AuthProvider>(context).user?.id ?? 1;

    final screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount;
    if (screenWidth <= 900) {
      crossAxisCount = 3;
    } else if (screenWidth <= 1100) {
      crossAxisCount = 5;
    } else {
      crossAxisCount = 6; // You can set any default value for larger screens
    }

    void fetchSessionId(int userId, int agentId, String agentName,
        String agentGander, String? agentImage) async {
      showDialog(
        context: context,
        barrierDismissible: false, // Prevent dialog dismissal
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            content: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SpinKitChasingDots(
                    color: AppColors.primaryColor,
                  ),
                  Text(
                    "Calling",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    agentName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ), // Show loader
          );
        },
      );

      try {
        var response = await callConversationProvider
            .fetchCallConversationResponse(userId, agentId, '', null, username);
        setState(() {
          sessionId = response['SessionID'];
          agentAudio = response['AIDialoagAudio'];
          aiDialog = response['AIDialoag'];
          aiDialogBn = response['AIDialoagBn'];
          /*aiDialogue = response['AIDialoag'];
          aiDialogueAudio = response['AIDialoagAudio'];
          aiTranslation = response['AIDialoagBn'];
          isLoading = false;*/
        });
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CallingScreen(
              sessionId: sessionId!,
              agentId: agentId,
              agentName: agentName,
              agentImage: agentImage,
              agentGander: agentGander,
              agentAudio: agentAudio!,
              firstText: aiDialog!,
              firstTextBn: aiDialogBn!,
            ),
          ),
        );

        // print("$sessionId, $aiDialogue");
      } catch (e) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Error"),
              content: Text(e.toString()),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );
        // Handle error
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Contacts",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Level up your language skills by conversing with characters from around the world.",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              child: FutureBuilder<void>(
                future:
                    callingAgentListProvider.fetchCallingAgentListResponse(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: SpinKitThreeInOut(
                      color: AppColors.primaryColor,
                    ));
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    // final data = snapshot.data!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: callingAgentListProvider
                          .callingAgentListResponse!.agentlist!
                          .map((countryData) {
                        return Card(
                          clipBehavior: Clip.hardEdge,
                          color: AppColors.backgroundColorDark,
                          child: Container(
                            child: Theme(
                              data: Theme.of(context)
                                  .copyWith(dividerColor: Colors.transparent),
                              child: ExpansionTile(
                                  iconColor: AppColors.primaryColor,
                                  collapsedBackgroundColor:
                                      AppColors.primaryColor2.withOpacity(0.05),
                                  backgroundColor:
                                      AppColors.primaryColor.withOpacity(0.2),
                                  title: Text(
                                    countryData.country ?? "",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  children: [
                                    GridView.builder(
                                      shrinkWrap: true,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: crossAxisCount,
                                        crossAxisSpacing: 8.0,
                                        mainAxisSpacing: 8.0,
                                      ),
                                      physics: BouncingScrollPhysics(),
                                      itemCount: countryData.agents!.length,
                                      itemBuilder: (context, index) {
                                        final agent =
                                            countryData.agents![index];
                                        String agentPicture =
                                            "assets/images/profile_chat.png";
                                        return GestureDetector(
                                          onTap: () {
                                            fetchSessionId(
                                                userId,
                                                agent.id!,
                                                agent.agentName!,
                                                agent.agentGender!,
                                                agent.agentPicture);
                                          },
                                          child: Card(
                                            color: AppColors.primaryColor
                                                .withOpacity(0.5),
                                            child: Container(
                                              padding: EdgeInsets.all(8.0),
                                              child: Column(
                                                children: [
                                                  Flexible(
                                                    flex: 3,
                                                    child: Container(
                                                      child:
                                                          agent.agentPicture ==
                                                                  null
                                                              ? Image.asset(
                                                                  "assets/images/profile_chat.png",
                                                                  fit: BoxFit
                                                                      .fitHeight,
                                                                )
                                                              : Image.network(
                                                                  agent
                                                                      .agentPicture!,
                                                                  fit: BoxFit
                                                                      .fitHeight,
                                                                  loadingBuilder: (BuildContext
                                                                          context,
                                                                      Widget
                                                                          child,
                                                                      ImageChunkEvent?
                                                                          loadingProgress) {
                                                                    if (loadingProgress ==
                                                                        null)
                                                                      return child;
                                                                    return Center(
                                                                      child:
                                                                          CircularProgressIndicator(
                                                                        value: loadingProgress.expectedTotalBytes !=
                                                                                null
                                                                            ? loadingProgress.cumulativeBytesLoaded /
                                                                                loadingProgress.expectedTotalBytes!
                                                                            : null,
                                                                      ),
                                                                    );
                                                                  },
                                                                ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Flexible(
                                                    flex: 1,
                                                    child: Text(
                                                      agent.agentName ?? "",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 2,
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ]),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
