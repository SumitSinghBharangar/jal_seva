import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:jal_seva/common/app_colors.dart';
import 'package:jal_seva/common/buttons/scale_button.dart';
import 'package:jal_seva/routing/routes.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
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
          "Help and Support",
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
            _listTile(
              icon: Iconsax.call,
              title: "Customer Support Contact",
              onTap: () {
                _showSupportModel();
              },
            ),
            SizedBox(height: 15.h),
            _listTile(
              icon: Iconsax.message_2,
              title: "Support Chat",
              onTap: () {
                context.push(Routes.chatScreen.path);
              },
            ),
            SizedBox(height: 15.h),
            _listTile(
              icon: Icons.feedback_outlined,
              title: "Submit Feedback",
              onTap: () {
                context.push(Routes.feedbackFormScreen.path);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _listTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: ScaleButton(
        onTap: () {
          onTap();
        },
        scale: .98,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            boxShadow: [
              BoxShadow(blurRadius: 12, color: Colors.black.withOpacity(.05)),
            ],
          ),
          child: Row(
            children: [
              Icon(icon),
              const SizedBox(width: 24),
              Text(title),
              const Spacer(),
              const Icon(Iconsax.arrow_right_3),
            ],
          ),
        ),
      ),
    );
  }

  _showSupportModel() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return GestureDetector(
          onVerticalDragEnd: (details) {
            if (details.primaryVelocity != null &&
                details.primaryVelocity! > 0) {
              Navigator.pop(context);
            }
          },
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Container(
              height: MediaQuery.sizeOf(context).height * .3,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    SizedBox(height: 15.h),
                    Center(
                      child: Container(
                        height: 5.h,
                        width: 30.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    SizedBox(height: 30.h),
                    ScaleButton(
                      scale: 0.97,
                      onTap: () {},
                      child: Material(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            leading: const Icon(Iconsax.call),
                            title: Text(
                              "Conatact Number",
                              style: TextStyle(
                                fontSize: 19.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              "+919917709350",
                              style: TextStyle(
                                fontSize: 17.sp,
                                color: Colors.grey,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    ScaleButton(
                      scale: 0.97,
                      onTap: () {},
                      child: Material(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            leading: const Icon(Icons.email_outlined),
                            title: Text(
                              "Email",
                              style: TextStyle(
                                fontSize: 19.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              "bharangarsinghsumit@gmail.com",
                              style: TextStyle(
                                fontSize: 17.sp,
                                color: Colors.grey,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
