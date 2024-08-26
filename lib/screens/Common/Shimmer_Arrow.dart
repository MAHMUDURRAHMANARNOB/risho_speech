import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:iconsax/iconsax.dart';
import 'package:risho_speech/ui/colors.dart';

class ShimmerArrow extends StatefulWidget {
  const ShimmerArrow({super.key});

  @override
  State<ShimmerArrow> createState() => _ShimmerArrowState();
}

class _ShimmerArrowState extends State<ShimmerArrow>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    // TODO: implement initState
    _animationController = AnimationController.unbounded(vsync: this)
      ..repeat(min: -0.5, max: 1.5, period: Duration(seconds: 1));
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (_, child) {
        return ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            transform:
                _slideGradientTransform(percent: _animationController.value),
            colors: [
              Colors.white10,
              AppColors.primaryColor,
              Colors.white10,
            ],
          ).createShader(bounds),
          child: child,
        );
      },
      child: const Column(
        children: [
          Align(
              heightFactor: 0.4, child: Icon(Icons.keyboard_arrow_up_rounded)),
          Align(
              heightFactor: 0.4, child: Icon(Icons.keyboard_arrow_up_rounded)),
          Align(
              heightFactor: 0.4, child: Icon(Icons.keyboard_arrow_up_rounded)),
        ],
      ),
    );
  }
}

class _slideGradientTransform extends GradientTransform {
  final double percent;

  _slideGradientTransform({required this.percent});

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    // TODO: implement transform
    return Matrix4.translationValues(0, -bounds.height * percent, 0);
  }
}
