import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jal_seva/common/app_colors.dart';
import 'package:jal_seva/routing/routes.dart';
import 'package:lottie/lottie.dart';

class EmptySubscriptionScreen extends StatefulWidget {
  const EmptySubscriptionScreen({super.key});

  @override
  State<EmptySubscriptionScreen> createState() =>
      _EmptySubscriptionScreenState();
}

class _EmptySubscriptionScreenState extends State<EmptySubscriptionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          context.push(Routes.newSubscription.path);
        },
        child: Icon(Icons.add_box_outlined, size: 35.h),
      ),
      appBar: AppBar(
        backgroundColor: AppColors.appDarkColor,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Icon(Icons.arrow_back, size: 28.h, color: Colors.white),
        ),
        title: Text(
          "Your Subscriptions",
          style: TextStyle(
            fontSize: 20.sp,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 22.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset(
              "assets/lottie/no-subscription.json",
              height: 300.h,
              width: 300.w,
              fit: BoxFit.cover,
            ),
            Text(
              "No Subscription found",
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 5.h),
            Text(
              "Subscribe Now",
              style: TextStyle(color: Colors.grey, fontSize: 15.sp),
            ),
          ],
        ),
      ),
    );
  }
}
