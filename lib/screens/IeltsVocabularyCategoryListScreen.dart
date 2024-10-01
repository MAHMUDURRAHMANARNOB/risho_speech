import 'package:flutter/material.dart';
import 'package:risho_speech/screens/tablet/IeltsVocabularyCategoryListScreenTablet.dart';

import '../responsive/responsive_layout.dart';
import 'Mobile/IeltsVocabularyCategoryListScreenMobile.dart';

class IeltsVocabularyCategoryListScreen extends StatefulWidget {
  final int topicCategory;
  final String isIdioms;

  const IeltsVocabularyCategoryListScreen(
      {super.key, required this.topicCategory, required this.isIdioms});

  @override
  State<IeltsVocabularyCategoryListScreen> createState() =>
      _IeltsVocabularyCategoryListScreenState();
}

class _IeltsVocabularyCategoryListScreenState
    extends State<IeltsVocabularyCategoryListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileScaffold: IeltsVocabularyCategoryListScreenMobile(
          topicCategory: widget.topicCategory,
          isIdioms: widget.isIdioms,
        ),
        tabletScaffold: IeltsVocabularyCategoryListScreenMobile(
          topicCategory: widget.topicCategory,
          isIdioms: widget.isIdioms,
        ),
        desktopScaffold: IeltsVocabularyCategoryListScreenMobile(
          topicCategory: widget.topicCategory,
          isIdioms: widget.isIdioms,
        ),
      ),
    );
  }
}
