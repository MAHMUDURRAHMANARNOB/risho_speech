import 'package:flutter/material.dart';
import 'package:risho_speech/screens/tablet/IeltsSpeakingExamScreenTablet.dart';

import '../responsive/responsive_layout.dart';
import 'Mobile/IeltsSpeakingExamScreenMobile.dart';

class IeltsSpeakingExamScreen extends StatefulWidget {
  const IeltsSpeakingExamScreen({
    super.key,
  });

  @override
  State<IeltsSpeakingExamScreen> createState() =>
      _IeltsSpeakingExamScreenState();
}

class _IeltsSpeakingExamScreenState extends State<IeltsSpeakingExamScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileScaffold: IeltsSpeakingExamScreenMobile(),
        tabletScaffold: IeltsSpeakingExamScreenMobile(),
        desktopScaffold: IeltsSpeakingExamScreenMobile(),
      ),
    );
  }
}
