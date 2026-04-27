import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:jal_seva/common/app_colors.dart';
import 'package:jal_seva/common/buttons/dynamic_button.dart';
import 'package:jal_seva/common/buttons/scale_button.dart';
import 'package:jal_seva/common/constants/app_collections.dart';
import 'package:jal_seva/features/order/model/order_model.dart';
import 'package:jal_seva/features/wallet/model/transection_model.dart';
import 'package:jal_seva/features/wallet/widgets/transection_widget.dart';
import 'package:jal_seva/routing/routes.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  late Razorpay _razorpay;

  final String uid = FirebaseAuth.instance.currentUser!.uid;

  final List<String> imgList = ['assets/images/promo_container.png'];

  void _openTopUpRazorpay(num amount) {
    var options = {
      'key': 'rzp_test_0JYAov6Cmnw2l4',
      'amount': (amount * 100).toInt(),
      'name': 'Jal-Seva',
      'description': 'Wallet Top Up',
      'prefill': {
        'contact': FirebaseAuth.instance.currentUser?.phoneNumber ?? '',
        'email': FirebaseAuth.instance.currentUser?.email ?? '',
      },
      'theme': {'color': '#3399cc'},
    };

    try {
      _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handleTopUpSuccess);
      _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
      _razorpay.open(options);
    } catch (e) {
      print("Razorpay TopUp Error: $e");
      Fluttertoast.showToast(msg: "Something went wrong!");
    }
  }

  void _handleTopUpSuccess(PaymentSuccessResponse response) async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final amount =
          num.tryParse((response.data?['amount'] ?? '0').toString()) ?? 0;

      // Add amount to wallet
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'balance': FieldValue.increment(
          amount / 100,
        ), // convert paise back to INR
      });

      // Save topup transaction
      var transactionRef = FirebaseFirestore.instance
          .collection('transactions')
          .doc();

      TransactionModel transaction = TransactionModel(
        id: transactionRef.id,
        uid: uid,
        orderId: 'TOPUP', // no order for topup
        amount: amount / 100, // convert paise back to INR
        method: TxnPaymentMethod.razorpay,
        status: TxnPaymentStatus.success,
        paidAt: DateTime.now(),
        paymentId: response.paymentId,
        remark: 'Wallet Top Up',
      );

      await transactionRef.set(transaction.toMap());

      Fluttertoast.showToast(msg: "Wallet topped up successfully!");
    } catch (e) {
      print("TopUp Save Error: $e");
      Fluttertoast.showToast(msg: "Something went wrong!");
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("Payment Error: ${response.code} - ${response.message}");
    Fluttertoast.showToast(msg: "Payment Failed: ${response.message}");
  }

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handleTopUpSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

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
                      _showTopUpBottomSheet();
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
                    context.push(Routes.transectionScreen.path);
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

  void _showTopUpBottomSheet() {
    final TextEditingController amountController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom:
              MediaQuery.of(context).viewInsets.bottom + 20, // keyboard padding
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              "Top Up Wallet",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6),
            Text(
              "Enter amount to add to your wallet",
              style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
            ),

            SizedBox(height: 20),

            // Quick amount chips
            Wrap(
              spacing: 8,
              children: [100, 200, 500, 1000].map((amt) {
                return GestureDetector(
                  onTap: () {
                    amountController.text = amt.toString();
                  },
                  child: Chip(
                    label: Text("₹$amt"),
                    backgroundColor: Colors.blue.withOpacity(0.1),
                    labelStyle: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }).toList(),
            ),

            SizedBox(height: 16),

            // Amount input
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                prefixText: "₹  ",
                prefixStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black87,
                ),
                hintText: "Enter amount",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                ),
              ),
            ),

            SizedBox(height: 20),

            // Pay button
            SizedBox(
              width: double.infinity,
              child: DynamicButton(
                onPressed: () {
                  final amount = num.tryParse(amountController.text.trim());

                  // Validation
                  if (amount == null || amount <= 0) {
                    Fluttertoast.showToast(msg: "Please enter a valid amount!");
                    return;
                  }

                  if (amount < 10) {
                    Fluttertoast.showToast(msg: "Minimum topup amount is ₹10!");
                    return;
                  }

                  if (amount > 10000) {
                    Fluttertoast.showToast(
                      msg: "Maximum topup amount is ₹10,000!",
                    );
                    return;
                  }

                  Navigator.pop(context);
                  _openTopUpRazorpay(amount);
                },
                child: Text(
                  "Proceed to Pay",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
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
