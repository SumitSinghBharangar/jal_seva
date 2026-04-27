import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jal_seva/common/app_colors.dart';
import 'package:jal_seva/features/wallet/model/transection_model.dart';
import 'package:jal_seva/features/wallet/widgets/transection_widget.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.appDarkColor,
        elevation: 0,
        title: Text(
          "Transactions",
          style: TextStyle(
            fontSize: 22.h,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('transactions')
            .where('uid', isEqualTo: uid)
            .orderBy('paidAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          // Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // Error
          if (snapshot.hasError) {
            return Center(child: Text("Something went wrong!"));
          }

          // Empty
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 80,
                    color: Colors.grey.shade300,
                  ),
                  SizedBox(height: 16),
                  Text(
                    "No transactions yet",
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 16),
                  ),
                ],
              ),
            );
          }

          final transactions = snapshot.data!.docs
              .map(
                (doc) => TransactionModel.fromMap(
                  doc.data() as Map<String, dynamic>,
                ),
              )
              .toList();

          // Total summary
          final totalSpent = transactions
              .where((t) => t.status == TxnPaymentStatus.success)
              .fold<num>(0, (sum, t) => sum + t.amount);

          return Column(
            children: [
              Container(
                margin: EdgeInsets.all(16.sp),
                padding: EdgeInsets.all(16.sp),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade600, Colors.blue.shade400],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Total Spent",
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "₹$totalSpent",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Total Transactions",
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "${transactions.length}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // List
              Expanded(
                child: ListView.builder(
                  itemCount: transactions.length,
                  padding: EdgeInsets.only(bottom: 16),
                  itemBuilder: (context, index) {
                    return TransactionWidget(transaction: transactions[index]);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
