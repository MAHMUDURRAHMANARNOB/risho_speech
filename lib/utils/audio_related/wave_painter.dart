import 'package:flutter/material.dart';

class WavePainter extends CustomPainter {
  final List<double> waveData;

  WavePainter({required this.waveData});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final path = Path();
    final amplitude = size.height /
        2; // Adjust amplitude relative to the height of the container

    path.moveTo(0, size.height / 2);

    for (double i = 0; i < size.width; i++) {
      final y = size.height / 2 +
          amplitude *
              (waveData[(i / size.width * waveData.length).toInt()] - 0.5);
      path.lineTo(i, y);
    }

    path.lineTo(size.width, size.height / 2);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
