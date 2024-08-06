import 'package:flutter/material.dart';
import 'package:risho_speech/screens/Mobile/IELTSHomeScreenMobile.dart';
import 'package:risho_speech/screens/tablet/IELTSHomeScreenTablet.dart';

import '../responsive/responsive_layout.dart';

class IELTSHoneScreen extends StatefulWidget {
  const IELTSHoneScreen({super.key});

  @override
  State<IELTSHoneScreen> createState() => _IELTSHoneScreenState();
}

class _IELTSHoneScreenState extends State<IELTSHoneScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileScaffold: IELTSHomeScreenMobile(),
        tabletScaffold: IELTSHomeScreenMobile(),
        desktopScaffold: IELTSHomeScreenTablet(),
      ),
    );
  }
}
