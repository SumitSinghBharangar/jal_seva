import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jal_seva/common/app_colors.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.appDarkColor,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Icon(Icons.arrow_back, size: 28.h, color: Colors.white),
        ),
        title: Text(
          "About",
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
               "Jal-Seva",
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20.h),
            Text(
             
                  "Jal-Seva is committed to ensuring easy and reliable access to water by offering a platform to book water tanks for homes, businesses, and communities. The app's core mission is to address water scarcity and streamline water supply during emergencies or routine needs.\nBy connecting users with trusted suppliers, Gibili ensures timely and efficient water delivery, reducing the stress of managing water shortages. It promotes sustainable water distribution and helps meet the diverse water demands of urban and rural areas. Gibili is a dependable partner in ensuring every drop counts for a water-secure future.",
              textAlign: TextAlign.justify,
              style: const TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 10.h),
            Text(
             "App Version: 1.0.0",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
