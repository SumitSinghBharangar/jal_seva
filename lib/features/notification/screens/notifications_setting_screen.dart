import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jal_seva/common/app_colors.dart';

class NotificationSettingScreen extends StatefulWidget {
  const NotificationSettingScreen({super.key});

  @override
  State<NotificationSettingScreen> createState() =>
      _NotificationSettingScreenState();
}

class _NotificationSettingScreenState extends State<NotificationSettingScreen> {
  bool isGeneralNotificationsEnabled = true;
  bool isSoundEnabled = true;
  bool isVibrationEnbled = false;
  bool isAppUdate = true;
  bool isBillRemainder = true;
  bool isPromotions = false;
  bool isDiscounts = true;
  bool isPayments = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 28.h),
        ),
        backgroundColor: AppColors.appDarkColor,
        title: Text(
          "Notification Settings",
          style: TextStyle(
            fontSize: 20.sp,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.h),
              Text(
                "General",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17.sp,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 5.h),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(
                        0.3,
                      ), // Shadow color with light opacity
                      // spreadRadius: 2, // Spread radius
                      // blurRadius: 2, // Blur radius
                      offset: const Offset(1, 1), // Offset in x and y direction
                    ),
                  ],
                ),
                child: ListTile(
                  title: Text(
                    "General Notifications",
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  trailing: Switch(
                    value: isGeneralNotificationsEnabled,
                    onChanged: (value) {
                      setState(() {
                        isGeneralNotificationsEnabled = value;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 15.h),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      offset: const Offset(1, 1),
                    ),
                  ],
                ),
                child: ListTile(
                  title: Text(
                    "Sounds",
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  trailing: Switch(
                    value: isSoundEnabled,
                    onChanged: (value) {
                      setState(() {
                        isSoundEnabled = value;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 15.h),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      offset: const Offset(1, 1),
                    ),
                  ],
                ),
                child: ListTile(
                  title: Text(
                    "Vibration",
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  trailing: Switch(
                    activeColor: AppColors.appDarkColor,
                    value: isVibrationEnbled,
                    onChanged: (value) {
                      setState(() {
                        isVibrationEnbled = value;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 15.h),
              Text(
                "System and Service Updates",
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 15.sp),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      offset: const Offset(1, 1),
                    ),
                  ],
                ),
                child: ListTile(
                  title: Text(
                    "App Updates",
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  trailing: Switch(
                    activeColor: AppColors.appDarkColor,
                    value: isAppUdate,
                    onChanged: (value) {
                      setState(() {
                        isAppUdate = value;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 15.h),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      offset: const Offset(1, 1),
                    ),
                  ],
                ),
                child: ListTile(
                  title: Text(
                    "Bill Remainder",
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  trailing: Switch(
                    activeColor: AppColors.appDarkColor,
                    value: isBillRemainder,
                    onChanged: (value) {
                      setState(() {
                        isBillRemainder = value;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 15.h),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      offset: const Offset(1, 1),
                    ),
                  ],
                ),
                child: ListTile(
                  title: Text(
                    "Promotions",
                    style: TextStyle(
                      fontSize: 19.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  trailing: Switch(
                    activeColor: AppColors.appDarkColor,
                    value: isPromotions,
                    onChanged: (value) {
                      setState(() {
                        isPromotions = value;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 15.h),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      offset: const Offset(1, 1),
                    ),
                  ],
                ),
                child: ListTile(
                  title: Text(
                    "Discount",
                    style: TextStyle(
                      fontSize: 19.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  trailing: Switch(
                    activeColor: AppColors.appDarkColor,
                    value: isDiscounts,
                    onChanged: (value) {
                      setState(() {
                        isDiscounts = value;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 15.h),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      offset: const Offset(1, 1),
                    ),
                  ],
                ),
                child: ListTile(
                  title: Text(
                    "Payments",
                    style: TextStyle(
                      fontSize: 19.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  trailing: Switch(
                    activeColor: AppColors.appDarkColor,
                    value: isPayments,
                    onChanged: (value) {
                      setState(() {
                        isPayments = value;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }
}
