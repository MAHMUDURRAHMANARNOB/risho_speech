import 'package:flutter/material.dart';

class PracticeListeningScreenMobile extends StatefulWidget {
  const PracticeListeningScreenMobile({super.key});

  @override
  State<PracticeListeningScreenMobile> createState() =>
      _PracticeListeningScreenMobileState();
}

class _PracticeListeningScreenMobileState
    extends State<PracticeListeningScreenMobile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Practice Listening"),
      ),
    );
  }
}
