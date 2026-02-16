import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jal_seva/common/app_colors.dart';
import 'package:jal_seva/common/buttons/scale_button.dart';
import 'package:jal_seva/features/order/screens/previous_orders.dart';
import 'package:jal_seva/features/order/screens/upcomming_orders.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  bool previousSelected = false;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: AppColors.appDarkColor,
            child: Column(
              children: [
                SizedBox(height: MediaQuery.paddingOf(context).top + 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Orders",
                        style: TextStyle(
                          fontSize: 20.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 15.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ScaleButton(
                            onTap: !previousSelected
                                ? null
                                : () {
                                    setState(() {
                                      previousSelected = false;
                                    });
                                    _pageController.previousPage(
                                      duration: const Duration(
                                        milliseconds: 400,
                                      ),
                                      curve: Curves.fastEaseInToSlowEaseOut,
                                    );
                                  },
                            child: AnimatedContainer(
                              width: 150.w,
                              duration: const Duration(milliseconds: 400),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: previousSelected ? null : Colors.white,
                                border: Border.all(
                                  color: !previousSelected
                                      ? AppColors.buttonColor
                                      : Colors.white,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: Text(
                                  "Upcoming",
                                  style: TextStyle(
                                    color: previousSelected
                                        ? Colors.white
                                        : AppColors.appDarkColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 11.w),
                          ScaleButton(
                            onTap: previousSelected
                                ? null
                                : () {
                                    setState(() {
                                      previousSelected = true;
                                    });
                                    _pageController.nextPage(
                                      duration: const Duration(
                                        milliseconds: 400,
                                      ),
                                      curve: Curves.fastEaseInToSlowEaseOut,
                                    );
                                  },
                            child: AnimatedContainer(
                              width: 150.w,
                              padding: EdgeInsets.symmetric(
                                horizontal: 20.w,
                                vertical: 8.h,
                              ),
                              decoration: BoxDecoration(
                                color: !previousSelected ? null : Colors.white,
                                border: Border.all(
                                  color: previousSelected
                                      ? AppColors.buttonColor
                                      : Colors.white,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              duration: const Duration(milliseconds: 400),
                              child: Center(
                                child: Text(
                                  "Previous",
                                  style: TextStyle(
                                    color: !previousSelected
                                        ? Colors.white
                                        : AppColors.appDarkColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
              ],
            ),
          ),
          Expanded(
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              children: const [UpcommingOrders(), PreviousOrders()],
            ),
          ),
        ],
      ),
    );
  }
}

// class OrdersScreen extends StatefulWidget {
//   const OrdersScreen({super.key});

//   @override
//   State<OrdersScreen> createState() => _OrdersScreenState();
// }

// class _OrdersScreenState extends State<OrdersScreen> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FirestoreListView.separated(
//       padding: EdgeInsets.zero,
//       query: ordersCollection
//           .where('driverId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
//           .orderBy('createdAt', descending: true),
//       emptyBuilder: (context) => _emptyState(context),
//       separatorBuilder: (context, index) => const SizedBox(height: 22),
//       itemBuilder: (context, doc) {
//         OrderModel orderModel = OrderModel.fromMap(doc.data());

//         return OrderCard(orderModel: orderModel);
//       },
//     );
//   }

//   Column _emptyState(BuildContext context) {
//     return Column(
//       children: [
//         const Spacer(),
//         Image.asset(
//           'assets/images/clip_board.png',
//           width: MediaQuery.sizeOf(context).width / 3,
//         ),
//         const SizedBox(height: 30),
//         const Text(
//           "No order",
//           style: TextStyle(
//             fontSize: 32,
//             fontWeight: FontWeight.w900,
//           ),
//         ),
//         const Text(
//           "There are no order till now",
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.normal,
//           ),
//         ),
//         const Spacer(),
//       ],
//     );
//   }
// }
