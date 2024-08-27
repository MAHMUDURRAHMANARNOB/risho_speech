import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:risho_speech/providers/IeltsVocabularyCategoryListProvider.dart';
import 'package:risho_speech/screens/IeltsVocabularyListScreen.dart';

import '../../ui/colors.dart';

class IeltsVocabularyCategoryListScreenMobile extends StatefulWidget {
  final int topicCategory; //1,2,3,4
  final String isIdioms; //1,2,3,4
  const IeltsVocabularyCategoryListScreenMobile(
      {super.key, required this.topicCategory, required this.isIdioms});

  @override
  State<IeltsVocabularyCategoryListScreenMobile> createState() =>
      _IeltsVocabularyCategoryListScreenMobileState();
}

class _IeltsVocabularyCategoryListScreenMobileState
    extends State<IeltsVocabularyCategoryListScreenMobile> {
  IeltsVocabularyCategoryListProvider ieltsvocabularyCategoryListProvider =
      IeltsVocabularyCategoryListProvider();

  @override
  Widget build(BuildContext context) {
    String categoryName = "";
    switch (widget.topicCategory) {
      case 1:
        // do something
        setState(() {
          categoryName = "Speaking";
        });
        break;
      case 2:
        // do something
        setState(() {
          categoryName = "Reading";
        });
        break;
      case 3:
        // do something
        setState(() {
          categoryName = "Listening";
        });
        break;
      case 4:
        // do something
        setState(() {
          categoryName = "Writing";
        });
        break;
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Vocabulary Category",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            children: [
              RichText(
                text: TextSpan(
                  text: 'These are some categories for ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: categoryName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                        fontSize: 18,
                      ),
                    ),
                    TextSpan(
                      text: ' vocabularies',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10.0),
              _vocabCategoryList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _vocabCategoryList() {
    return FutureBuilder<void>(
      future: ieltsvocabularyCategoryListProvider
          .fetchIeltsVocabularyCategoryList(widget.topicCategory),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: SpinKitThreeInOut(
              color: AppColors.primaryColor,
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            itemCount: ieltsvocabularyCategoryListProvider
                .vocabularyCategories!.vocaCatList.length,
            itemBuilder: (context, index) {
              final category = ieltsvocabularyCategoryListProvider
                  .vocabularyCategories!.vocaCatList[index];
              return GestureDetector(
                onTap: () {
                  // Fluttertoast.showToast(msg: category.lessonId.toString());
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => IeltsVocabularyListScreen(
                        vocabularyCategoryId: category.id,
                        isIdioms: widget.isIdioms,
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 5.0),
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: AppColors.vocabularyCatCardColor,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          category.topicName,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      SizedBox(width: 5.0),
                      Icon(
                        IconsaxPlusBold.arrow_circle_right,
                        color: AppColors.primaryColor,
                        size: 34,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
