import 'package:flutter/material.dart';

class VocabularyPracticeScreenMobile extends StatefulWidget {
  final String categoryId;
  const VocabularyPracticeScreenMobile({super.key, required this.categoryId});

  @override
  State<VocabularyPracticeScreenMobile> createState() =>
      _VocabularyPracticeScreenMobileState();
}

class _VocabularyPracticeScreenMobileState
    extends State<VocabularyPracticeScreenMobile> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(widget.categoryId),
    );
  }
}
