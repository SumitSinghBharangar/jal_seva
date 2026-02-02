import 'package:flutter/material.dart';
import 'dart:math';

class ShakeAnimation extends StatefulWidget {
  final Widget child;
  final bool isAnimating;

  const ShakeAnimation({
    super.key,
    required this.child,
    required this.isAnimating,
  });

  @override
  ShakeAnimationState createState() => ShakeAnimationState();
}

class ShakeAnimationState extends State<ShakeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration:
          const Duration(milliseconds: 300),
    );

    _animation = Tween<double>(begin: 0, end: 48)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(_controller);
  }

  @override
  void didUpdateWidget(covariant ShakeAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAnimating && !oldWidget.isAnimating) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_animation.value * sin(_controller.value * pi * 3), 0),
          child: widget.child,
        );
      },
    );
  }
}