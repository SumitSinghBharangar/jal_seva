import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:jal_seva/common/app_colors.dart';
import 'package:jal_seva/common/buttons/scale_button.dart';
import 'package:jal_seva/routing/routes.dart';
import 'package:jal_seva/utils.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    var user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.appDarkColor,

        title: Text(
          "Profile",
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        // centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30.h),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.network(
                    user.photoURL ??
                        "https://static.vecteezy.com/system/resources/thumbnails/032/176/191/small_2x/business-avatar-profile-black-icon-man-of-user-symbol-in-trendy-flat-style-isolated-on-male-profile-people-diverse-face-for-social-network-or-web-vector.jpg",
                  ),
                ),
                title: Text(
                  user.displayName!,
                  style: TextStyle(fontSize: 19.sp, color: Colors.black),
                ),
                subtitle: Text(
                  user.phoneNumber!,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.black.withOpacity(0.85),
                  ),
                ),
                trailing: IconButton(
                  onPressed: () {
                    if (context.mounted) {
                      context.push(Routes.profileEditScreen.path);
                    }
                  },
                  icon: Icon(Iconsax.edit, color: AppColors.appDarkColor),
                ),
              ),
            ),
            SizedBox(height: 10.h),
            _profileTile(
              icon: Iconsax.crown,
              title: 'Subscription',
              onTap: () {
                context.push(Routes.subscription.path);
              },
            ),
            _profileTile(
              icon: Iconsax.map,
              title: "Saved Addresses",
              onTap: () {
                context.push(Routes.savedAddresses.path);
              },
            ),

            _profileTile(
              icon: Iconsax.message,
              title: "Notification Setting",
              onTap: () {
                context.push(Routes.notificationSettingScreen.path);
              },
            ),
            _profileTile(
              icon: Iconsax.like_dislike,
              title: "Help and Support",
              onTap: () {
                // context.push(Routes.chatScreen.path);
                context.push(Routes.helpSupportScreen.path);
              },
            ),
            _profileTile(
              icon: Iconsax.info_circle,
              title: "About Us",
              onTap: () {
                context.push(Routes.aboutScreen.path);
              },
            ),
            _profileTile(
              icon: Iconsax.logout,
              title: "Log Out",
              onTap: () async {
                _showLogOutModel();
              },
            ),
            SizedBox(height: MediaQuery.paddingOf(context).bottom + 30),
          ],
        ),
      ),
    );
  }

  Widget _profileTile({
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

  _showLogOutModel() {
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
                    Text(
                      "Are You Sure to Logout",
                      style: TextStyle(
                        fontSize: 17.sp,
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 15.h),
                    Text(
                      "For your Security",
                      style: TextStyle(
                        color: Colors.grey,
                        decoration: TextDecoration.none,
                        fontSize: 13.5.sp,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    ScaleButton(
                      onTap: () {
                        context.pop();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.grey.shade100,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 12.h,
                        ),
                        child: Center(
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              fontSize: 19.sp,
                              decoration: TextDecoration.none,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15.h),
                    ScaleButton(
                      onTap: () async {
                        showLoading(context);

                        var uid = FirebaseAuth.instance.currentUser!.uid;

                        await FirebaseAuth.instance.signOut();

                        if (context.mounted) {
                          context.pop();
                          context.go(Routes.splash.path);
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.red,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 12.h,
                        ),
                        child: Center(
                          child: Text(
                            "Yes LogOut",
                            style: TextStyle(
                              decoration: TextDecoration.none,
                              fontSize: 19.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
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
