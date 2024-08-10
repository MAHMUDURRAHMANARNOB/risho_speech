import 'package:flutter/material.dart';
import 'package:risho_speech/screens/tablet/IeltsListeningExamScreenTablet.dart';

import '../responsive/responsive_layout.dart';
import 'Mobile/IeltsListeningExamScreenMobile.dart';

class IeltsListeningExamScreen extends StatefulWidget {
  const IeltsListeningExamScreen({super.key});

  @override
  State<IeltsListeningExamScreen> createState() =>
      _IeltsListeningExamScreenState();
}

class _IeltsListeningExamScreenState extends State<IeltsListeningExamScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileScaffold: IeltsListeningExamScreenMobile(),
        tabletScaffold: IeltsListeningExamScreenMobile(),
        desktopScaffold: IeltsListeningExamScreenTablet(),
      ),
    );
  }
}
