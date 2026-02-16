

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jal_seva/common/constants/app_collections.dart';
import 'package:jal_seva/features/order/model/order_model.dart';
import 'package:jal_seva/features/order/screens/upcomming_orders.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';

class PreviousOrders extends StatefulWidget {
  const PreviousOrders({super.key});

  @override
  State<PreviousOrders> createState() => _PreviousOrdersState();
}

class _PreviousOrdersState extends State<PreviousOrders> {
  @override
  Widget build(BuildContext context) {
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 22.w),
      child: FirestoreListView.separated(
        separatorBuilder: (context, index) => SizedBox(height: 10.h),
        query: ordersCollection
            .where(
              'uid',
              isEqualTo: FirebaseAuth.instance.currentUser!.uid,
            )
            .where('isClosed', isEqualTo: true)
            .orderBy('createdAt', descending: true),
        emptyBuilder: (context) => _emptyState(context),
        itemBuilder: (context, doc) {
          OrderModel orderModel = OrderModel.fromMap(doc.data());

          return OrderCard(orderModel: orderModel);
        },
      ),
    );
  }

  Column _emptyState(BuildContext context) {
    
    return Column(
      children: [
        const Spacer(),
        Lottie.asset(
          'assets/lottie/no_Order.json',
          width: MediaQuery.sizeOf(context).width / 3,
        ),
        const SizedBox(height: 30),
        Text(
           "No Order",
          style: TextStyle(
            fontSize: 32.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
        Text(
          "You've no order till now",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.normal,
          ),
        ),
        const Spacer(),
      ],
    );
  }
}
