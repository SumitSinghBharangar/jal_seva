import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jal_seva/features/wallet/model/transection_model.dart';

class TransactionWidget extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionWidget({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isRazorpay = transaction.method == TxnPaymentMethod.razorpay;
    final isSuccess = transaction.status == TxnPaymentStatus.success;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isSuccess
                  ? Colors.green.withOpacity(0.1)
                  : Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isRazorpay ? Icons.payment : Icons.account_balance_wallet,
              color: isSuccess ? Colors.green : Colors.red,
              size: 24,
            ),
          ),

          SizedBox(width: 12),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isRazorpay ? "Razorpay" : "App Wallet",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                ),
                SizedBox(height: 4),
                Text(
                  "Order #${transaction.orderId.substring(0, 8).toUpperCase()}",
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                ),
                SizedBox(height: 2),
                Text(
                  DateFormat('dd MMM yyyy, hh:mm a').format(transaction.paidAt),
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 11),
                ),
              ],
            ),
          ),

          // Amount + Status
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "₹${transaction.amount}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 4),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isSuccess
                      ? Colors.green.withOpacity(0.1)
                      : transaction.status == TxnPaymentStatus.pending
                      ? Colors.orange.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  transaction.status.name.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: isSuccess
                        ? Colors.green
                        : transaction.status == TxnPaymentStatus.pending
                        ? Colors.orange
                        : Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
