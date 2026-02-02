import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:jal_seva/common/animations/fade_in.dart';
import 'package:jal_seva/common/app_colors.dart';
import 'package:jal_seva/routing/routes.dart';
import 'package:lottie/lottie.dart';

class OnbaordingScreen extends StatefulWidget {
  const OnbaordingScreen({super.key});

  @override
  State<OnbaordingScreen> createState() => _OnbaordingScreenState();
}

class _OnbaordingScreenState extends State<OnbaordingScreen> {
  PageController pageController = PageController();

  double page = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusManager.instance.primaryFocus?.unfocus();
    });
    pageController.addListener(() {
      setState(() {
        page = pageController.page ?? 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Spacer(),
          FadeInAnimation(
            delay: 3,
            child: SizedBox.square(
              dimension: MediaQuery.sizeOf(context).width,
              child: Stack(
                children: [
                  ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      AppColors.buttonColor,
                      BlendMode.srcIn,
                    ),
                    child: Lottie.asset('assets/lottie/wave.json'),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFDCD4BF),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(200),
                        child: Image.asset(
                          'assets/images/logo.jpeg',
                          height: MediaQuery.sizeOf(context).width * .3,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          Expanded(
            child: FadeInAnimation(
              delay: 2,
              child: PageView(
                controller: pageController,
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                children: [
                  _buildOnboardingText(
                    title: 'Welcome to Gibili',
                    subtitle: "Water tank filling system.",
                  ),
                  _buildOnboardingText(
                    title: 'Water Delivery, Anytime',
                    subtitle: "Book water tankers easily and quickly.",
                  ),
                  _buildOnboardingText(
                    title: 'Fresh Water, On Demand',
                    subtitle: "Your water supply, at your fingertips.",
                  ),
                  _buildOnboardingText(
                    title: 'Never Run Dry Again',
                    subtitle: "Secure your water supply with a tap.",
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          FadeInAnimation(
            delay: 1.5,
            child: SizedBox(
              height: 80,
              width: 80,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CircularProgressIndicator(
                      color: AppColors.buttonColor.withOpacity(.8),
                      strokeWidth: 4,
                      strokeCap: StrokeCap.round,
                      value: (((page) + 1) / 4),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: IconButton(
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.buttonColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(15),
                      ),
                      onPressed: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        if (page + 1 >= 4) {
                          context.go(Routes.login.path);
                        }
                        pageController.nextPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.fastEaseInToSlowEaseOut,
                        );
                      },
                      icon: const Icon(Iconsax.arrow_right_1, size: 40),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: MediaQuery.paddingOf(context).bottom + 48),
        ],
      ),
    );
  }

  Column _buildOnboardingText({
    required String title,
    required String subtitle,
  }) {
    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: AppColors.buttonColor,
          ),
        ),
        Text(
          subtitle,
          style: TextStyle(fontSize: 16, color: AppColors.buttonColor),
        ),
      ],
    );
  }
}
