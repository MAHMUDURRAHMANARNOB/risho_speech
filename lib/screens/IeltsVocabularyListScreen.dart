import 'package:flutter/material.dart';
import 'package:risho_speech/responsive/responsive_layout.dart';
import 'package:risho_speech/screens/tablet/IeltsVocabularyListScreenTablet.dart';

import 'Mobile/IeltsVocabularyListScreenMobile.dart';

class IeltsVocabularyListScreen extends StatefulWidget {
  final int vocabularyCategoryId;
  final String isIdioms;

  const IeltsVocabularyListScreen(
      {super.key, required this.vocabularyCategoryId, required this.isIdioms});

  @override
  State<IeltsVocabularyListScreen> createState() =>
      _IeltsVocabularyListScreenState();
}

class _IeltsVocabularyListScreenState extends State<IeltsVocabularyListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
          mobileScaffold: IeltsVocabularyListScreenMobile(
            vocabularyCategoryId: widget.vocabularyCategoryId,
            isIdioms: widget.isIdioms,
          ),
          tabletScaffold: IeltsVocabularyListScreenMobile(
            vocabularyCategoryId: widget.vocabularyCategoryId,
            isIdioms: widget.isIdioms,
          ),
          desktopScaffold: IeltsVocabularyListScreenMobile(
            vocabularyCategoryId: widget.vocabularyCategoryId,
            isIdioms: widget.isIdioms,
          )),
    );
  }
}
