import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';

class SpeakingTestReportScreenMobile extends StatefulWidget {
  final String report;

  const SpeakingTestReportScreenMobile({super.key, required this.report});

  @override
  State<SpeakingTestReportScreenMobile> createState() =>
      _SpeakingTestReportScreenMobileState();
}

class _SpeakingTestReportScreenMobileState
    extends State<SpeakingTestReportScreenMobile> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height; // Gives the height
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Report'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Container(
            height: height - 80,
            child: MarkdownWidget(
              data: widget.report,
              // style: const TextStyle(fontSize: 16.0),
            ),
          ),
        ),
      ),
    );
  }
}
