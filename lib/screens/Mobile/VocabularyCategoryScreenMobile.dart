import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:risho_speech/providers/vocabularyPracticeListProvider.dart';

import '../../models/vocabularyCategoryListDataModel.dart';
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

  TextEditingController _searchTextController = TextEditingController();
  List<VocalCat> _filteredCategories = [];

  /*@override
  void initState() {
    super.initState();
    vocabularyProvider.fetchVocabularyCategoryList();
  }*/
  @override
  void initState() {
    super.initState();
    vocabularyProvider = VocabularyCategoryListProvider();
    _searchTextController.addListener(_filterCategories);
    _fetchData();
  }

  @override
  void dispose() {
    _searchTextController.removeListener(_filterCategories);
    _searchTextController.dispose();
    super.dispose();
  }

  void _filterCategories() {
    final query = _searchTextController.text.toLowerCase();
    setState(() {
      _filteredCategories = vocabularyProvider
          .vocabularyCategoryResponse!.vocalListlist!
          .where(
              (category) => category.vocCatName!.toLowerCase().contains(query))
          .toList();
    });
  }

  Future<void> _fetchData() async {
    await vocabularyProvider.fetchVocabularyCategoryList();
    setState(() {
      _filteredCategories =
          vocabularyProvider.vocabularyCategoryResponse!.vocalListlist!;
    });
  }

  String capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1).toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    final username =
        Provider.of<AuthProvider>(context).user?.name ?? 'UserName';
    final userId = Provider.of<AuthProvider>(context).user?.id ?? 1;

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
              /*Padding(
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
              ),*/
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  cursorColor: AppColors.primaryColor,
                  controller: _searchTextController,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide(
                        color: AppColors.primaryColor, // Change to your color
                      ),
                    ),
                    prefixIconColor: AppColors.primaryColor,
                    prefixIcon: Icon(Icons.search),
                    hintText: "Search for the type of Vocabulary",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: AppColors.primaryColor, // Change to your color
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 8.0,
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
                      itemCount: /* vocabularyProvider
                          .vocabularyCategoryResponse!.vocalListlist!.length*/
                          _filteredCategories.length,
                      itemBuilder: (context, index) {
                        final category = /*vocabularyProvider
                            .vocabularyCategoryResponse!.vocalListlist![index]*/
                            _filteredCategories[index];
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
                            color: AppColors.primaryCardColor,
                            clipBehavior: Clip.antiAlias,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    width: double.infinity,
                                    color: AppColors.vocabularyCatCardColor,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: category.imageUrl == null
                                          ? Image.asset(
                                              "assets/images/risho_guru_icon.png",
                                              height: 200,
                                            )
                                          : Image.network(
                                              category.imageUrl!,
                                              height: 200,
                                              fit: BoxFit.fitHeight,
                                              loadingBuilder:
                                                  (BuildContext context,
                                                      Widget child,
                                                      ImageChunkEvent?
                                                          loadingProgress) {
                                                if (loadingProgress == null) {
                                                  return child;
                                                }
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    color:
                                                        AppColors.primaryColor,
                                                    value: loadingProgress
                                                                .expectedTotalBytes !=
                                                            null
                                                        ? loadingProgress
                                                                .cumulativeBytesLoaded /
                                                            loadingProgress
                                                                .expectedTotalBytes!
                                                        : null,
                                                  ),
                                                );
                                              },
                                            ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    capitalize(category.vocCatName ?? ""),
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                /*Expanded(
                                  flex: 1,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      capitalize(category.vocCatNameBn ?? ""),
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),*/
                                /*Text(
                                  capitalize(category.vocaDescription ?? ""),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                ),*/
                              ],
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
