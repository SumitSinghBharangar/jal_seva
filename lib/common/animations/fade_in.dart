import 'package:flutter/material.dart';

class FadeInAnimation extends StatefulWidget {
  const FadeInAnimation({super.key, required this.delay, required this.child});

  final Widget child;
  final double delay;

  @override
  State<FadeInAnimation> createState() => _FadeInAnimationState();
}

class _FadeInAnimationState extends State<FadeInAnimation>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;
  late Animation<double> animation2;
  @override
  void didUpdateWidget(covariant FadeInAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.delay != oldWidget.delay) {
      controller.forward(from: 0);
    }
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(milliseconds: (1000 * widget.delay).round()),
      vsync: this,
    );
    animation2 =
        Tween<double>(begin: 150 * widget.delay, end: 0).animate(
          CurvedAnimation(
            parent: controller,
            curve: Curves.fastEaseInToSlowEaseOut,
          ),
        )..addListener(() {
          setState(() {
            // The state that has changed here is the animation object’s value.
          });
        });

    animation =
        Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
            parent: controller,
            curve: Curves.fastEaseInToSlowEaseOut,
          ),
        )..addListener(() {
          setState(() {
            // The state that has changed here is the animation object’s value.
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    controller.forward();
    return Transform.scale(
      scale: animation.value,
      child: Transform.translate(
        offset: Offset(0, animation2.value),
        child: Opacity(opacity: animation.value, child: widget.child),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class FadeInAnimation2 extends StatefulWidget {
  const FadeInAnimation2({super.key, required this.delay, required this.child});

  final Widget child;
  final double delay;

  @override
  State<FadeInAnimation2> createState() => _FadeInAnimationState2();
}

class _FadeInAnimationState2 extends State<FadeInAnimation2>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;
  late Animation<double> animation2;
  @override
  void didUpdateWidget(covariant FadeInAnimation2 oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.delay != oldWidget.delay) {
      controller.forward(from: 0);
    }
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(milliseconds: (1000 * widget.delay).round()),
      vsync: this,
    );
    animation2 =
        Tween<double>(begin: 150 * widget.delay, end: 0).animate(
          CurvedAnimation(
            parent: controller,
            curve: Curves.fastEaseInToSlowEaseOut,
          ),
        )..addListener(() {
          setState(() {
            // The state that has changed here is the animation object’s value.
          });
        });

    animation =
        Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
            parent: controller,
            curve: Curves.fastEaseInToSlowEaseOut,
          ),
        )..addListener(() {
          setState(() {
            // The state that has changed here is the animation object’s value.
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    controller.forward();
    return Transform.translate(
      offset: Offset(0, animation2.value),
      child: Opacity(opacity: animation.value, child: widget.child),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
