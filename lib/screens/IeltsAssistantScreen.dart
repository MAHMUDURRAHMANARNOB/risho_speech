import 'package:flutter/material.dart';
import 'package:risho_speech/screens/Mobile/IeltsAssistantScreenMobile.dart';
import 'package:risho_speech/screens/tablet/IeltsAssistantScreenTablet.dart';

import '../responsive/responsive_layout.dart';

class IeltsAssistantScreen extends StatefulWidget {
  const IeltsAssistantScreen({super.key});

  @override
  State<IeltsAssistantScreen> createState() => _IeltsAssistantScreenState();
}

class _IeltsAssistantScreenState extends State<IeltsAssistantScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileScaffold: IeltsAssistantScreenMobile(),
        tabletScaffold: IeltsAssistantScreenMobile(),
        desktopScaffold: IeltsAssistantScreenMobile(),
      ),
    );
  }
}
