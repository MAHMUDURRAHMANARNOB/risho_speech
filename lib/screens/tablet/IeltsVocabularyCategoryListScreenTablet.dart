import 'package:flutter/material.dart';

class IeltsVocabularyCategoryListScreenTablet extends StatefulWidget {
  final int topicCategory;
  final String isIdioms;

  const IeltsVocabularyCategoryListScreenTablet(
      {super.key, required this.topicCategory, required this.isIdioms});

  @override
  State<IeltsVocabularyCategoryListScreenTablet> createState() =>
      _IeltsVocabularyCategoryListScreenTabletState();
}

class _IeltsVocabularyCategoryListScreenTabletState
    extends State<IeltsVocabularyCategoryListScreenTablet> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
