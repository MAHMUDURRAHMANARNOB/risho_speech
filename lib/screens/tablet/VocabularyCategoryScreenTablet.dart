import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';
import 'package:risho_speech/providers/vocabularyPracticeListProvider.dart';

import '../../models/vocabularyCategoryListDataModel.dart';
import '../../providers/auth_provider.dart';
import '../../providers/vocabularyCategoryListProvider.dart';
import '../../ui/colors.dart';
import '../VocabularyPracticeScreen.dart';

class VocabularyCategoryScreenTablet extends StatefulWidget {
  const VocabularyCategoryScreenTablet({super.key});

  @override
  State<VocabularyCategoryScreenTablet> createState() =>
      _VocabularyCategoryScreenTabletState();
}

class _VocabularyCategoryScreenTabletState
    extends State<VocabularyCategoryScreenTablet> {
  VocabularyCategoryListProvider vocabularyProvider =
      VocabularyCategoryListProvider();
  VocabularyPracticeProvider vocabularyPracticeProvider =
      VocabularyPracticeProvider();

  TextEditingController _searchTextController = TextEditingController();
  List<VocalCat> _filteredCategories = [];

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

  Future<void> _refresh() async {
    // userId = Provider.of<AuthProvider>(context).user!.id;
    // userName = Provider.of<AuthProvider>(context).user!.name;
    // final userId = Provider.of<AuthProvider>(context, listen: false).user?.id;
    await vocabularyProvider.fetchVocabularyCategoryList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount;
    if (screenWidth <= 900) {
      crossAxisCount = 4;
    } else if (screenWidth <= 1100) {
      crossAxisCount = 5;
    } else {
      crossAxisCount = 6; // You can set any default value for larger screens
    }

    final username =
        Provider.of<AuthProvider>(context).user?.name ?? 'UserName';
    final userId = Provider.of<AuthProvider>(context).user?.id ?? 1;

    return Scaffold(
      appBar: AppBar(
        title: Text("Vocabulary Category"),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: LiquidPullToRefresh(
        onRefresh: _refresh,
        showChildOpacityTransition: false,
        springAnimationDurationInMilliseconds: 1000,
        color: AppColors.secondaryCardColor,
        backgroundColor: AppColors.primaryColor,
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
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
                          crossAxisCount: crossAxisCount,
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
                                  builder: (context) =>
                                      VocabularyPracticeScreen(
                                    categoryId: category.id!,
                                    categoryName: category.vocCatName!,
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              clipBehavior: Clip.antiAlias,
                              child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        width: double.infinity,
                                        color: Colors.white,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
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
                                                    if (loadingProgress == null)
                                                      return child;
                                                    return Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                        color: AppColors
                                                            .primaryColor,
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
                                      height: 10,
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
      ),
    );
  }
}
