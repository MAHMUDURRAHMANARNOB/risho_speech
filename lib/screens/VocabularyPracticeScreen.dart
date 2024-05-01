import 'package:flutter/material.dart';
import 'package:risho_speech/screens/tablet/VocabularyPracticeScreenTablet.dart';

import '../responsive/responsive_layout.dart';
import 'Mobile/VocabularyPracticeScreenMobile.dart';

class VocabularyCategoryScreen extends StatefulWidget {
  final String categoryId;
  const VocabularyCategoryScreen({super.key, required this.categoryId});

  @override
  State<VocabularyCategoryScreen> createState() =>
      _VocabularyCategoryScreenState();
}

class _VocabularyCategoryScreenState extends State<VocabularyCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileScaffold: VocabularyPracticeScreenMobile(
          categoryId: widget.categoryId,
        ),
        tabletScaffold: VocabularyPracticeScreenTablet(),
        desktopScaffold: VocabularyPracticeScreenTablet(),
      ),
    );
  }
}
