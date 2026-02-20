import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jal_seva/common/buttons/dynamic_button.dart';

class TermUseScreen extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();
  TermUseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 24.h),
        child: Column(
          children: [
            Expanded(
              child: ScrollbarTheme(
                data: ScrollbarThemeData(
                  thumbColor: MaterialStateProperty.all(
                    Colors.green,
                  ), // Change thumb color
                  trackColor: MaterialStateProperty.all(
                    Colors.transparent,
                  ), // Change track color
                  trackVisibility: MaterialStateProperty.all(
                    true,
                  ), // Show track
                  thickness: MaterialStateProperty.all(
                    8,
                  ), // Thickness of the scrollbar
                  radius: Radius.circular(10), // Rounded corners
                ),
                child: Scrollbar(
                  thumbVisibility: true,
                  controller: _scrollController,
                  thickness: 8.0,
                  radius: const Radius.circular(10),
                  scrollbarOrientation: ScrollbarOrientation.right,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 40.h),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Terms of Use",
                              style: TextStyle(
                                fontSize: 26.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 32.h),
                          RichText(
                            textAlign: TextAlign.justify,
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 17.sp,
                                color: Colors.black,
                              ),
                              children: const [
                                TextSpan(
                                  text:
                                      "Welcome to our Drinking Water Delivery Application. By registering or using this application, you agree to comply with the following terms and conditions\n",
                                ),
                                TextSpan(
                                  text: "\n1. Service Description.\n",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 21,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      "\nThis application provides doorstep delivery of drinking water through subscription-based and instant ordering options. Delivery schedules depend on user selection and service availability in your area.\n",
                                ),

                                TextSpan(
                                  text: "\n2. User Responsibilities.\n",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 21,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      "\nUsers must provide accurate personal information, delivery address, and contact details. Any misuse of the application, including false orders or incorrect details, may result in suspension of the account.\n",
                                ),
                                TextSpan(
                                  text: "\n3. Orders and Subscription\n",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 21,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      "\nSubscription plans will be delivered as per the selected schedule. Instant orders are subject to availability and confirmation. Users can modify or cancel orders within the allowed time limit.\n",
                                ),
                                TextSpan(
                                  text: "\n4. Payments\n",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 21,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      "\nAll payments must be completed through the available payment methods in the application. Prices may vary depending on quantity and location.\n",
                                ),
                                TextSpan(
                                  text: "\n5. Service Availability\n",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 21,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      "\nDelivery timing may vary due to traffic, weather, or unforeseen circumstances.\n",
                                ),
                                TextSpan(
                                  text: "\n6. Privacy\n",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 21,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      "\nUser information will be kept secure and used only for order processing and service improvement.\n\nBy continuing to use this application, you agree to these terms and conditions.",
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 70.h),
                          Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              width: 300,
                              child: DynamicButton(
                                style: FilledButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.zero,
                                ),
                                onPressed: () {
                                  if (context.mounted) {
                                    Navigator.pop(context);
                                  }
                                },
                                child: Text(
                                  "Continue",
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20.h),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
