import 'package:flutter/material.dart';
import 'package:risho_speech/screens/tablet/VocabularyPracticeScreenTablet.dart';

import '../responsive/responsive_layout.dart';
import 'Mobile/VocabularyPracticeScreenMobile.dart';

class VocabularyPracticeScreen extends StatefulWidget {
  final int categoryId;
  const VocabularyPracticeScreen({super.key, required this.categoryId});

  @override
  State<VocabularyPracticeScreen> createState() =>
      _VocabularyCategoryScreenState();
}

class _VocabularyCategoryScreenState extends State<VocabularyPracticeScreen> {
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
