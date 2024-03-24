import 'package:flutter/material.dart';

import '../responsive/navigation_page.dart';

class Dashboard extends StatefulWidget {
  static const String id = "dashboard_screen";

  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int selectedIndex = 0;

  void handleScreenChange(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        title: Text('DASHBOARD'),
      ),*/
      // Add the navigation drawer to the Scaffold
      body: NavigationPage(),
    );
  }
}
