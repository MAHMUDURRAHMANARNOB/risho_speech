import 'package:flutter/material.dart';

class CallingScreenMobile extends StatefulWidget {
  final String agentId;
  final String sessionId;
  const CallingScreenMobile(
      {super.key, required this.agentId, required this.sessionId});

  @override
  State<CallingScreenMobile> createState() => _CallingScreenMobileState();
}

class _CallingScreenMobileState extends State<CallingScreenMobile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("${widget.agentId} -- ${widget.sessionId}"),
      ),
    );
  }
}
