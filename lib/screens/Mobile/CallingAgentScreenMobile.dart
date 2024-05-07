import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:risho_speech/providers/callAndConversationProvider.dart';
import 'package:risho_speech/screens/CallingScreen.dart';
import 'package:risho_speech/ui/colors.dart';

import '../../models/CallingAgentDataModel.dart';
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

    void fetchSessionId(
        int userId, int agentId, String agentName, String agentGander) async {
      showDialog(
        context: context,
        barrierDismissible: false, // Prevent dialog dismissal
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            content: Center(
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
        child: Container(
          child: FutureBuilder<void>(
            future: callingAgentListProvider.fetchCallingAgentListResponse(),
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
                              /*collapsedBackgroundColor:
                                  Colors.blue.withOpacity(0.1),*/
                              backgroundColor:
                                  AppColors.primaryColor.withOpacity(0.2),
                              title: Text(
                                countryData.country ?? "",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              children: [
                                GridView.builder(
                                  shrinkWrap: true,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount:
                                        MediaQuery.of(context).size.width > 600
                                            ? 4
                                            : 3,
                                    crossAxisSpacing: 8.0,
                                    mainAxisSpacing: 8.0,
                                  ),
                                  physics: BouncingScrollPhysics(),
                                  itemCount: countryData.agents!.length,
                                  itemBuilder: (context, index) {
                                    final agent = countryData.agents![index];
                                    return GestureDetector(
                                      onTap: () {
                                        fetchSessionId(
                                            userId,
                                            agent.id!,
                                            agent.agentName!,
                                            agent.agentGender!);
                                      },
                                      child: Card(
                                        color: AppColors.primaryColor
                                            .withOpacity(0.5),
                                        child: Container(
                                          padding: EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Image.asset(
                                                "assets/images/profile_chat.png",
                                                height: 30,
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                agent.agentName ?? "",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: "Mina",
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                textAlign: TextAlign.center,
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
      ),
    );
  }
}
