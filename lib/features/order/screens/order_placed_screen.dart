import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jal_seva/common/animations/fade_in.dart';
import 'package:jal_seva/common/buttons/dynamic_button.dart';
import 'package:jal_seva/routing/routes.dart';
import 'package:lottie/lottie.dart';

class OrderPlacedScreen extends StatefulWidget {
  const OrderPlacedScreen({super.key});

  @override
  State<OrderPlacedScreen> createState() => _OrderPlacedScreenState();
}

class _OrderPlacedScreenState extends State<OrderPlacedScreen>
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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
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
                      FadeInAnimation2(
                        delay: 1,
                        child: Center(
                          child: ScaleTransition(
                            scale: _animation2,
                            child: Lottie.network(
                              "https://lottie.host/ea5ba71f-6c51-47be-a44f-d982b8a733bd/mnQhIiF09I.json",
                              height: 200.h,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      FadeInAnimation2(
                        delay: 1,
                        child: Text(
                          "Order Placed",
                          style: TextStyle(
                            fontSize: 32.sp,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      FadeInAnimation2(
                        delay: 1.5,
                        child: Text(
                          "Your Order Successfully Placed",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(flex: 3),
                  FadeInAnimation2(
                    delay: 2,
                    child: DynamicButton.fromText(
                      text: "Go Back",
                      onPressed: () {
                        context.go(Routes.order.path);
                      },
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
