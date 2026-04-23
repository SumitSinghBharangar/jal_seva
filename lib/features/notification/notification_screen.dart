import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:jal_seva/common/app_colors.dart';
import 'package:jal_seva/common/buttons/scale_button.dart';
import 'package:jal_seva/common/constants/app_collections.dart';
import 'package:jal_seva/features/notification/model/notification_model.dart';
import 'package:shimmer/shimmer.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  ValueNotifier<bool?> isListEmptyNotifier = ValueNotifier<bool?>(null);
  NotificationModel? model;
  List<NotificationModel> notifications = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.appDarkColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Iconsax.arrow_left, color: Colors.white),
        ),
        title: Text(
          "Notifications",
          style: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: false,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 22.w),
              child: StreamBuilder<QuerySnapshot>(
                stream: notificationsCollection
                    .where("to", isEqualTo: uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Shimmer.fromColors(
                      baseColor: Colors.grey.withOpacity(0.4),
                      highlightColor: Colors.grey.shade400,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 22.w),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              const SizedBox(height: 10 + 16 + 32),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(22),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(.5),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(.05),
                                      blurRadius: 20,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    FractionallySizedBox(
                                      widthFactor: .6,
                                      child: Container(
                                        height: 16,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 16.h),
                                    FractionallySizedBox(
                                      widthFactor: .4,
                                      child: Container(
                                        height: 12,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 16.h),
                                    Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(.5),
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              .05,
                                            ),
                                            blurRadius: 20,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          FractionallySizedBox(
                                            widthFactor: .6,
                                            child: Container(
                                              height: 16.h,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 16.h),
                                          FractionallySizedBox(
                                            widthFactor: .4,
                                            child: Container(
                                              height: 12.h,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 16.h),
                                          FractionallySizedBox(
                                            widthFactor: .4,
                                            child: Container(
                                              height: 12.h,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 16.h),
                                          FractionallySizedBox(
                                            widthFactor: .4,
                                            child: Container(
                                              height: 12.h,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 16.h),
                                    Container(
                                      height:
                                          MediaQuery.sizeOf(context).height *
                                          .3,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              .05,
                                            ),
                                            blurRadius: 20,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      width: double.infinity,
                                    ),
                                    SizedBox(height: 16.h),
                                    Container(
                                      height:
                                          MediaQuery.sizeOf(context).height *
                                          .3,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              .05,
                                            ),
                                            blurRadius: 20,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      width: double.infinity,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          FractionallySizedBox(
                                            widthFactor: .4,
                                            child: Container(
                                              height: 12.h,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 16.h),
                                          FractionallySizedBox(
                                            widthFactor: .4,
                                            child: Container(
                                              height: 12.h,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          FractionallySizedBox(
                                            widthFactor: .4,
                                            child: Container(
                                              height: 12.h,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 16.h),
                                          FractionallySizedBox(
                                            widthFactor: .4,
                                            child: Container(
                                              height: 12.h,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    // return Center(
                    //   child: Text("no data available"),
                    // );
                    return _emptyState(context);
                  }
                  final notificationDocs = snapshot.data!.docs;

                  return ListView.separated(
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(height: 20.h);
                    },
                    itemCount: notificationDocs.length,
                    itemBuilder: (context, index) {
                      final doc = notificationDocs[index];
                      NotificationModel notificationModel =
                          NotificationModel.fromMap(
                            doc.data() as Map<String, dynamic>,
                          );
                      return NotificationCard(
                        notificationModel: notificationModel,
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Column _emptyState(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 100.h),
        Image.asset(
          "assets/images/llustration.png",
          height: 250.h,
          fit: BoxFit.cover,
        ),
        SizedBox(height: 30.h),
        Text(
          "There is no Notifications",
          style: TextStyle(fontSize: 21.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10.h),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: "Your Notification Appear On This Page",
            style: TextStyle(fontSize: 22.sp, color: Colors.black),
          ),
        ),
      ],
    );
  }
}

class NotificationCard extends StatelessWidget {
  final NotificationModel notificationModel;

  const NotificationCard({super.key, required this.notificationModel});

  @override
  Widget build(BuildContext context) {
    return ScaleButton(
      scale: .98,
      onTap: () {},
      child: Container(
        padding: EdgeInsets.only(
          left: 20.w,
          top: 10.h,
          right: 14.w,
          bottom: 10.h,
        ),
        decoration: BoxDecoration(
          color: Colors.lightBlue.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Text(
                DateFormat('HH : mm').format(notificationModel.dateTime),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Iconsax.notification, size: 24),
                SizedBox(width: 10.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 5.h),
                    FittedBox(
                      child: Text(
                        notificationModel.body,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 5.h),
                    FittedBox(
                      child: Text(
                        notificationModel.title,
                        style: TextStyle(fontSize: 14.sp),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
