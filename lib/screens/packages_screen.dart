import 'package:flutter/material.dart';
import 'package:risho_speech/screens/tablet/packages_screen_tablet.dart';

import '../responsive/responsive_layout.dart';
import 'Mobile/packages_screen_mobile.dart';

class PackagesScreen extends StatefulWidget {
  static const String id = "packages_screen";

  const PackagesScreen({super.key});

  @override
  State<PackagesScreen> createState() => _PackagesScreenState();
}

class _PackagesScreenState extends State<PackagesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileScaffold: PackagesScreenMobile(),
        tabletScaffold: PackagesScreenMobile(),
        desktopScaffold: PackagesScreenMobile(),
      ),
    );
  }
}
