import 'package:flutter/material.dart';

class IeltsVocabularyListScreenTablet extends StatefulWidget {
  final int vocabularyCategoryId;
  final String isIdioms;

  const IeltsVocabularyListScreenTablet(
      {super.key, required this.vocabularyCategoryId, required this.isIdioms});

  @override
  State<IeltsVocabularyListScreenTablet> createState() =>
      _IeltsVocabularyListScreenTabletState();
}

class _IeltsVocabularyListScreenTabletState
    extends State<IeltsVocabularyListScreenTablet> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
