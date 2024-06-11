import 'package:flutter/material.dart';
import 'package:risho_speech/screens/tablet/VocabularyCategoryScreenTablet.dart';

import '../responsive/responsive_layout.dart';
import 'Mobile/CallingAgentScreenMobile.dart';
import 'Mobile/VocabularyCategoryScreenMobile.dart';

class VocabularyCategoryScreen extends StatefulWidget {
  VocabularyCategoryScreen({super.key});

  @override
  State<VocabularyCategoryScreen> createState() =>
      _VocabularyCategoryScreenState();
}

class _VocabularyCategoryScreenState extends State<VocabularyCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileScaffold: VocabularyCategoryScreenMobile(),
        tabletScaffold: VocabularyCategoryScreenTablet(),
        desktopScaffold: VocabularyCategoryScreenTablet(),
      ),
    );
  }
}
