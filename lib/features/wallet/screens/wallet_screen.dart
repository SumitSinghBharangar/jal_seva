import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jal_seva/common/app_colors.dart';
import 'package:jal_seva/common/buttons/scale_button.dart';
import 'package:jal_seva/common/constants/app_collections.dart';
import 'package:jal_seva/features/order/model/order_model.dart';
import 'package:jal_seva/features/wallet/model/transection_model.dart';
import 'package:jal_seva/features/wallet/widgets/transection_widget.dart';
import 'package:jal_seva/routing/routes.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  final List<String> imgList = ['assets/images/promo_container.png'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.appDarkColor,
        title: Text(
          "Wallet",
          style: TextStyle(
            fontSize: 22.h,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Wallet Container
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 22.0),
              height: 200.h,
              width: MediaQuery.sizeOf(context).width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: const DecorationImage(
                  image: AssetImage("assets/images/wallete_bg.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 30.h),
                  Image.asset("assets/icons/wallet.png"),
                  SizedBox(height: 5.h),
                  Text(
                    "Available Balance",
                    style: TextStyle(fontSize: 14.sp, color: Colors.black),
                  ),
                  Flexible(
                    child: StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Text("Fetching"); // Show loading indicator
                        }
                        return Text(
                          "₹ ${snapshot.data?["balance"] ?? 0}",
                          style: TextStyle(
                            fontSize: 30.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 7.h),
                  ScaleButton(
                    scale: .97,
                    onTap: () {
                      context.push(Routes.topupScreen.path);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 5.0,
                      ),
                      child: Text(
                        "Top Up",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.appDarkColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10.0),
            // Recent Transactions Header
            Row(
              children: [
                Text(
                  "Recent Transactions",
                  style: TextStyle(
                    fontSize: 20.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                ScaleButton(
                  scale: 0.97,
                  onTap: () {
                    context.push(Routes.historyScreen.path);
                  },
                  child: Text(
                    "View All",
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: AppColors.appDarkColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('transactions')
                    .where(
                      "uid",
                      isEqualTo: FirebaseAuth.instance.currentUser!.uid,
                    )
                    .orderBy('paidAt', descending: true)
                    .limit(5)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No transactions found'));
                  }

                  final docs = snapshot.data!.docs;

                  return ListView.separated(
                    separatorBuilder: (context, index) =>
                        SizedBox(height: 10.h),
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      TransactionModel transaction = TransactionModel.fromMap(
                        docs[index].data() as Map<String, dynamic>,
                      );
                      return TransactionWidget(transaction: transaction);
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 10.h),
            CarouselSlider(
              options: CarouselOptions(
                height: 150.0,
                autoPlay: true,
                enlargeCenterPage: true,
                aspectRatio: 16 / 9,
                autoPlayInterval: const Duration(seconds: 3),
                viewportFraction: .9,
              ),
              items: imgList
                  .map(
                    (item) => Center(
                      child: Image.asset(item, fit: BoxFit.cover, width: 1000),
                    ),
                  )
                  .toList(),
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }
}
