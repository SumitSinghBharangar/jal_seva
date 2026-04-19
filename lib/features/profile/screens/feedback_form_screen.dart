import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jal_seva/common/app_colors.dart';
import 'package:jal_seva/common/buttons/dynamic_button.dart';

class FeedbackFormScreen extends StatefulWidget {
  const FeedbackFormScreen({super.key});

  @override
  State<FeedbackFormScreen> createState() => _FeedbackFormScreenState();
}

class _FeedbackFormScreenState extends State<FeedbackFormScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.appDarkColor,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Text(
          "Submit Feedback",
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
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            Text(
              "Let us know how we can improve",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20.h),
            Container(
              height: 320.h,
              padding: EdgeInsets.all(10.h),
              decoration: BoxDecoration(
                color: Colors.white, // Background color
                border: Border.all(
                  color: Colors.grey.shade300, // Light grey border color
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const TextField(
                maxLines: null,
                expands: true,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Write down your feedback..",
                ),
              ),
            ),
            SizedBox(height: 25.h),
            DynamicButton.fromText(text: "Submit", onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
