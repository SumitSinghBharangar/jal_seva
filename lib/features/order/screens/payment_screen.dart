// import 'dart:io';

// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:jal_seva/common/animations/fade_in.dart';

// class PaymentScreen extends StatefulWidget {
//   final PaymentConfig paymentConfig;
//   final Function onPaymentResult;

//   const PaymentScreen({
//     super.key,
//     required this.paymentConfig,
//     required this.onPaymentResult,
//   });

//   @override
//   State<PaymentScreen> createState() => _PaymentScreenState();
// }

// class _PaymentScreenState extends State<PaymentScreen> {
//   final List<String> imgList = [
//     'assets/images/credit_card1.png',
//     'assets/images/credit_card2.png',
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       child: Scaffold(
//         appBar: AppBar(
//           leading: IconButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             icon: const Icon(Iconsax.arrow_left),
//           ),
//           title: Text(
//             "Payment",
//             style: TextStyle(fontSize: 21.sp, fontWeight: FontWeight.bold),
//           ),
//           centerTitle: true,
//         ),
//         body: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             mainAxisSize: MainAxisSize.max,
//             children: [
//               CarouselSlider(
//                 options: CarouselOptions(
//                   height: 200.0,
//                   autoPlay: true,
//                   enlargeCenterPage: true,
//                   aspectRatio: 16 / 9,
//                   autoPlayInterval: const Duration(seconds: 3),
//                   viewportFraction: 1,
//                 ),
//                 items: imgList
//                     .map(
//                       (item) => Center(
//                         child: Image.asset(
//                           item,
//                           fit: BoxFit.cover,
//                           width: 1000,
//                         ),
//                       ),
//                     )
//                     .toList(),
//               ),
//               SizedBox(height: 10.h),
//               if (Platform.isIOS)
//                 FadeInAnimation(
//                   delay: 1.5,
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 10),
//                     child: ApplePay(
//                       config: widget.paymentConfig,
//                       onPaymentResult: widget.onPaymentResult,
//                     ),
//                   ),
//                 )
//               else
//                 const SizedBox.shrink(),
//               FadeInAnimation(
//                 delay: 2.1,
//                 child: CreditCard(
//                   config: widget.paymentConfig,
//                   onPaymentResult: widget.onPaymentResult,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
