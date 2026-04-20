// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:go_router/go_router.dart';
// import 'package:jal_seva/common/animations/fade_in.dart';
// import 'package:jal_seva/common/app_colors.dart';

// class CardPaymentScreen extends StatefulWidget {
//   final PaymentConfig paymentConfig;
//   final Function onPaymentResult;
//   const CardPaymentScreen({
//     super.key,
//     required this.onPaymentResult,
//     required this.paymentConfig,
//   });

//   @override
//   State<CardPaymentScreen> createState() => _CardPaymentScreenState();
// }

// class _CardPaymentScreenState extends State<CardPaymentScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColors.appDarkColor,
//         title: Text(
//           "Card Payment",
//           style: TextStyle(
//             fontSize: 20.sp,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//         leading: IconButton(
//           onPressed: () {
//             context.pop();
//           },
//           icon: Icon(Icons.arrow_back, size: 28.h, color: Colors.white),
//         ),
//       ),
//       body: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 24.w),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(height: 20.h),
//             FadeInAnimation(
//               delay: 1.2,
//               child: CreditCard(
//                 config: widget.paymentConfig,
//                 onPaymentResult: widget.onPaymentResult,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
