import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jal_seva/common/buttons/dynamic_button.dart';

class SubscribedScreen extends StatefulWidget {
  const SubscribedScreen({super.key});

  @override
  State<SubscribedScreen> createState() => _SubscribedScreenState();
}

class _SubscribedScreenState extends State<SubscribedScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<double> _animation2;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      precacheImage(const AssetImage('assets/images/green_bg.png'), context);
      precacheImage(const AssetImage('assets/images/tick.png'), context);
    });

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    _animation = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _animation2 = Tween<double>(begin: .95, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.fastEaseInToSlowEaseOut,
      ),
    );

    _controller.addListener(() {
      if (mounted && context.mounted) {
        setState(() {});
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _controller.repeat(reverse: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: Colors.white),
        ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: 200, sigmaY: 200),
          child: RotationTransition(
            turns: _animation,
            child: Image.asset('assets/images/green_bg.png'),
          ),
        ),
        Positioned.fill(
          left: 22,
          right: 22,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Column(
              children: [
                const Spacer(flex: 3),
                Column(
                  children: [
                    Center(
                      child: ScaleTransition(
                        scale: _animation2,
                        child: Image.asset(
                          'assets/images/tick.png',
                          width: MediaQuery.sizeOf(context).width / 1.5,
                        ),
                      ),
                    ),
                    SizedBox(height: 30.h),
                    Text(
                      'Plan Subscribed',
                      style: TextStyle(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    // const SizedBox(height: 10),
                    Text(
                      "You've successfully subscribed a plan",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                const Spacer(flex: 3),
                DynamicButton.fromText(
                  text: "Go Back",
                  onPressed: () {
                    context.pop();
                    context.pop(true);
                  },
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
