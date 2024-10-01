import 'package:flutter/material.dart';
import 'package:risho_speech/screens/Mobile/TutorScreenMobile.dart';
import 'package:risho_speech/screens/tablet/TutorScreenTablet.dart';

import '../models/TutorResponseDataModel.dart';
import '../responsive/responsive_layout.dart';

class TutorScreen extends StatefulWidget {
  final TutorSuccessResponse tutorResponse;

  const TutorScreen({super.key, required this.tutorResponse});

  @override
  State<TutorScreen> createState() => _TutorScreenState();
}

class _TutorScreenState extends State<TutorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileScaffold: TutorScreenMobile(tutorResponse: widget.tutorResponse),
        tabletScaffold: TutorScreenMobile(tutorResponse: widget.tutorResponse),
        desktopScaffold: TutorScreenMobile(tutorResponse: widget.tutorResponse),
      ),
    );
  }
}
