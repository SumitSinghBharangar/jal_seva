
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jal_seva/common/app_colors.dart';
import 'package:jal_seva/common/buttons/scale_button.dart';
import 'package:jal_seva/common/constants/app_collections.dart';
import 'package:jal_seva/features/order/model/order_model.dart';
import 'package:jal_seva/routing/routes.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';

class UpcommingOrders extends StatefulWidget {
  const UpcommingOrders({super.key});

  @override
  State<UpcommingOrders> createState() => _UpcommingOrdersState();
}

class _UpcommingOrdersState extends State<UpcommingOrders> {
  @override
  void initState() {
    super.initState();
  }

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
            .where('isClosed', isEqualTo: false)
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
           "No order till now",
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

class OrderCard extends StatelessWidget {
  const OrderCard({
    super.key,
    required this.orderModel,
  });

  final OrderModel orderModel;

  @override
  Widget build(BuildContext context) {
   
    String formattedDate =
        DateFormat('dd MMM, yyyy h:mm a').format(orderModel.createdAt);
    return Container(
      width: 250.w,
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            color: Colors.black.withOpacity(.05),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                formattedDate,
                style: const TextStyle(color: Colors.grey),
              )
            ],
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                decoration: BoxDecoration(
                  color: orderModel.status == OrderStatus.pending
                      ? const Color(0xFFFFCC3D)
                      : orderModel.status == OrderStatus.delivered
                          ? Colors.green.shade800
                          : orderModel.status == OrderStatus.processing
                              ? Colors.blue.shade800
                              : orderModel.status == OrderStatus.shipped
                                  ? Colors.purple.shade800
                                  : Colors.red.shade800,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  orderModel.status.name.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                "${orderModel.totalCharge} SAR",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
          SizedBox(
            height: 7.h,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (orderModel.address.pipeImage != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    orderModel.address.pipeImage!,
                    height: 55,
                  ),
                ),
              if (orderModel.address.pipeImage == null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    "assets/images/truck.png",
                    height: 55,
                  ),
                ),
              SizedBox(
                width: 10.w,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${ "QTY"} ${orderModel.quantity} ${ "sq m"}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      orderModel.address.address,
                      style: const TextStyle(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Divider(
          //   height: .5,
          //   color: Colors.black.withOpacity(.2),
          // ),
          // const SizedBox(height: 10),
          // Row(
          //   children: [
          //     Text(
          //       DateFormat('MMM, dd ').add_jm().format(orderModel.createdAt),
          //     ),
          //     const Spacer(),
          //     Text(
          //       "\$ ${orderModel.totalCharge.toStringAsFixed(2)}",
          //     ),
          //   ],
          // ),
          ScaleButton(
            onTap: () {
              context.push(Routes.orderDetail.path, extra: orderModel);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.green.shade100.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
              child: Center(
                child: Text(
                  "View Order",
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.appDarkColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
