import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:risho_speech/providers/vocabularyPracticeListProvider.dart';

import '../../models/vocabularyCategoryListDataModel.dart';
import '../../models/vocabularyPracticeListDataModel.dart';
import '../../providers/auth_provider.dart';
import '../../providers/vocabularyCategoryListProvider.dart';
import '../../ui/colors.dart';
import '../VocabularyPracticeScreen.dart';

class VocabularyCategoryScreenMobile extends StatefulWidget {
  const VocabularyCategoryScreenMobile({super.key});

  @override
  State<VocabularyCategoryScreenMobile> createState() =>
      _VocabularyCategoryScreenMobileState();
}

class _VocabularyCategoryScreenMobileState
    extends State<VocabularyCategoryScreenMobile> {
  VocabularyCategoryListProvider vocabularyProvider =
      VocabularyCategoryListProvider();
  VocabularyPracticeProvider vocabularyPracticeProvider =
      VocabularyPracticeProvider();

  /*@override
  void initState() {
    super.initState();
    vocabularyProvider.fetchVocabularyCategoryList();
  }*/

  @override
  Widget build(BuildContext context) {
    final username =
        Provider.of<AuthProvider>(context).user?.name ?? 'UserName';
    final userId = Provider.of<AuthProvider>(context).user?.id ?? 1;

    List<dynamic>? vocaList = [];

    void fetchVocabulary(int categoryID, String categoryName) async {
      showDialog(
        context: context,
        barrierDismissible: false, // Prevent dialog dismissal
        builder: (BuildContext context) {
          return const Center(
            child: SpinKitChasingDots(
              color: Colors.green,
            ),
          );
        },
      );

      try {
        var response = await vocabularyPracticeProvider
            .fetchVocabularyPracticeList(categoryID);
        setState(() {
          // vocaList = response['vocaList'];
        });
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VocabularyPracticeScreen(
              categoryId: categoryID,
              categoryName: categoryName,
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
        title: Text("Vocabulary Category"),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                  "Which type of word you want to learn today?",
                  style: TextStyle(
                    color: AppColors.secondaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    fontFamily: 'mona',
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              FutureBuilder<void>(
                future: vocabularyProvider.fetchVocabularyCategoryList(),
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
                    print(vocabularyProvider
                        .vocabularyCategoryResponse!.vocalListlist!.length);
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            MediaQuery.of(context).size.width > 600 ? 2 : 2,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                      ),
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemCount: vocabularyProvider
                          .vocabularyCategoryResponse!.vocalListlist!.length,
                      itemBuilder: (context, index) {
                        final category = vocabularyProvider
                            .vocabularyCategoryResponse!.vocalListlist![index];
                        return GestureDetector(
                          onTap: () {
                            /*fetchSessionId(
                                    userId, agent.id!, agent.agentName!);*/
                            /*fetchVocabulary(category.id!);*/
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VocabularyPracticeScreen(
                                  categoryId: category.id!,
                                  categoryName: category.vocCatName!,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            child: Container(
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/images/office.png",
                                    height: 100,
                                    fit: BoxFit.fitHeight,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    category.vocCatName ?? "",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
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
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
