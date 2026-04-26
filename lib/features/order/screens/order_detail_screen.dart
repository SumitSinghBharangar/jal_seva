import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:jal_seva/common/animations/fade_in.dart';
import 'package:jal_seva/common/app_colors.dart';
import 'package:jal_seva/common/buttons/dynamic_button.dart';
import 'package:jal_seva/common/buttons/scale_button.dart';
import 'package:jal_seva/common/constants/app_collections.dart';
import 'package:jal_seva/features/order/model/order_model.dart';
import 'package:jal_seva/routing/routes.dart';
import 'package:jal_seva/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetailScreen extends StatefulWidget {
  const OrderDetailScreen({super.key, required this.model});

  @override
  State<OrderDetailScreen> createState() => OrderDetailScreenState();

  final OrderModel model;
}

class OrderDetailScreenState extends State<OrderDetailScreen> {
  Map<String, dynamic>? orderData;

  Future<void> _makePhoneCall(String phoneNumber) async {
    String url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      // Handle case where the phone number cannot be launched
      print('Could not launch $url');
    }
  }

  Future<void> _openSMSApp(String number) async {
    final Uri smsUri = Uri(scheme: 'sms', path: number);

    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri);
    } else {
      throw 'Could not launch SMS app';
    }
  }

  Future<void> _fetchOrderDetails() async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('orders')
          .doc(widget.model.id)
          .get();

      if (docSnapshot.exists) {
        setState(() {
          orderData = docSnapshot.data();
        });
      }
    } catch (e) {
      debugPrint('Error fetching order details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.appDarkColor,
        title: Text(
          "Order Details",
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: false,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 28.h),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 22.w),
        child: SizedBox.fromSize(
          size: MediaQuery.sizeOf(context),
          child: ListView(
            children: [
              const SizedBox(height: 16),
              const SizedBox(height: 32),
              FadeInAnimation2(
                delay: 1,
                child: Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Colors.white,
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
                      _buildSectionTitle("Order ID"),
                      Text(widget.model.id, style: _buildTextStyle()),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FadeInAnimation2(
                delay: 1.5,
                child: Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Colors.white,
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
                      _buildSectionTitle("Delivery Address"),
                      Text(widget.model.address.name, style: _buildTextStyle()),
                      Text(
                        widget.model.address.phone,
                        style: _buildTextStyle(),
                      ),
                      Text(
                        widget.model.address.address,
                        style: _buildTextStyle(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FadeInAnimation2(
                delay: 2.5,
                child: Container(
                  height: MediaQuery.sizeOf(context).height * .3,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.05),
                        blurRadius: 20,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  width: double.infinity,
                  child: GoogleMap(
                    myLocationButtonEnabled: false,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        widget.model.address.lat.toDouble(),
                        widget.model.address.lng.toDouble(),
                      ),
                      zoom: 15,
                    ),
                    markers: {
                      Marker(
                        markerId: const MarkerId('id'),
                        position: LatLng(
                          widget.model.address.lat.toDouble(),
                          widget.model.address.lng.toDouble(),
                        ),
                      ),
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FadeInAnimation2(
                delay: 2,
                child: Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Colors.white,
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
                      _buildSectionTitle("Order Details"),
                      _buildDetailRow(
                        "Quantity",
                        widget.model.quantity.toString(),
                      ),
                      _buildDetailRow(
                        "Total Charge",
                        '${widget.model.totalCharge.toStringAsFixed(2)} SAR',
                      ),
                      _buildDetailRow(
                        "Order Status",
                        widget.model.status.name.toUpperCase(),
                      ),
                      _buildDetailRow(
                        "Express Charage",
                        widget.model.isExpressDelivery ? 'Yes' : 'No',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FadeInAnimation2(
                delay: 2.5,
                child: Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Colors.white,
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
                      _buildSectionTitle("Order Date"),
                      Text(
                        DateFormat.yMMMd().add_jm().format(
                          widget.model.createdAt,
                        ),
                        style: _buildTextStyle(),
                      ),
                    ],
                  ),
                ),
              ),
              if (widget.model.rating != null) const SizedBox(height: 16),
              if (widget.model.rating != null)
                FadeInAnimation2(
                  delay: 3,
                  child: Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: Colors.white,
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
                        _buildSectionTitle("Your Feedback"),
                        Row(
                          children: [
                            Text(widget.model.rating!.toStringAsFixed(1)),
                            const SizedBox(width: 5),
                            const Icon(Iconsax.star, size: 12),
                          ],
                        ),
                        Row(children: [Text(widget.model.feedBack ?? "")]),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (widget.model.status != OrderStatus.cancelled &&
                      widget.model.rating == null &&
                      widget.model.status != OrderStatus.delivered)
                    Flexible(
                      child: DynamicButton.fromText(
                        text: "Track Order",
                        onPressed: () async {
                          await _fetchOrderDetails();
                          // context.push(Routes.viewStatusScreen.path);
                          _showTrackOrderModel(widget.model);
                        },
                      ),
                    ),
                  const SizedBox(width: 15),
                  if (widget.model.status != OrderStatus.cancelled &&
                      widget.model.status != OrderStatus.delivered)
                    Flexible(
                      child: DynamicButton.fromText(
                        text: "Cancel Order",
                        color: Colors.red.shade800,
                        onPressed: () async {
                          showLoading(context);

                          await ordersCollection.doc(widget.model.id).update({
                            'status': 'cancelled',
                            'isClosed': true,
                          });

                          if (context.mounted) {
                            context.pop();
                            context.pop();
                          }
                        },
                      ),
                    ),
                ],
              ),
              if (widget.model.status == OrderStatus.delivered &&
                  widget.model.rating == null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: DynamicButton.fromText(
                    text: "Rate Order",
                    color: Colors.green.shade800,
                    onPressed: () async {
                      await context.push(
                        Routes.rateOrder.path,
                        extra: widget.model,
                      );
                      setState(() {});
                    },
                  ),
                ),
              SizedBox(height: MediaQuery.paddingOf(context).bottom + 16),
            ],
          ),
        ),
      ),
    );
  }

  // Column _status({
  //   required Color color,
  //   required IconData iconData,
  //   required bool isActive,
  //   required String text,
  // }) {
  //   return Column(
  //     children: [
  //       Container(
  //         padding: const EdgeInsets.all(12),
  //         decoration: BoxDecoration(
  //           color: isActive ? color : Colors.grey,
  //           borderRadius: BorderRadius.circular(12),
  //         ),
  //         child: Icon(iconData),
  //       ),
  //       SizedBox(height: 10.h),
  //       Text(
  //         text,
  //         style: const TextStyle(
  //           fontSize: 16,
  //           fontWeight: FontWeight.bold,
  //         ),
  //       )
  //     ],
  //   );
  // }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: _buildTextStyle(fontWeight: FontWeight.w500)),
          Text(value, style: _buildTextStyle()),
        ],
      ),
    );
  }

  TextStyle _buildTextStyle({FontWeight fontWeight = FontWeight.normal}) {
    return TextStyle(
      fontSize: 16,
      fontWeight: fontWeight,
      color: Colors.grey[700],
    );
  }

  _showTrackOrderModel(OrderModel model) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        String formatDate(DateTime? dateTime) {
          if (dateTime == null) return "";
          return DateFormat('d MMM, yyyy h:mm a').format(dateTime);
        }

        String processedAt = formatDate(
          (orderData?["processedAt"] as Timestamp?)?.toDate(),
        );
        String shippedAt = formatDate(
          (orderData?["shippedAt"] as Timestamp?)?.toDate(),
        );
        String deliveredAt = formatDate(
          (orderData?["deliveredAt"] as Timestamp?)?.toDate(),
        );

        return GestureDetector(
          onVerticalDragEnd: (details) {
            if (details.primaryVelocity != null &&
                details.primaryVelocity! > 0) {
              Navigator.pop(context);
            }
          },
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.55,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 22.w),
                child: Material(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 15.h),
                      Center(
                        child: Container(
                          height: 5.h,
                          width: 40.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        "Activity Tracking",
                        style: TextStyle(
                          fontSize: 18.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 15.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 70.h,
                            width: 90.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color:
                                  (model.status != OrderStatus.pending &&
                                      model.status != OrderStatus.cancelled)
                                  ? AppColors.appDarkColor
                                  : Colors.grey.shade600,
                            ),
                            child: Center(
                              child: Icon(
                                Iconsax.box,
                                color: Colors.white,
                                size: 30.h,
                              ),
                            ),
                          ),
                          SizedBox(width: 20.w),
                          Flexible(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Order under processing",
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  "the Order has been accepted and is under processing",
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    color: Colors.grey,
                                  ),
                                ),
                                if (model.status != OrderStatus.pending &&
                                    model.status != OrderStatus.cancelled)
                                  Text(
                                    processedAt,
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: Colors.black.withOpacity(0.8),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 40.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 70.h,
                            width: 90.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color:
                                  (model.status == OrderStatus.shipped &&
                                      model.status == OrderStatus.delivered)
                                  ? AppColors.appDarkColor
                                  : Colors.grey.shade600,
                            ),
                            child: Center(
                              child: Icon(
                                Iconsax.truck,
                                color: Colors.white,
                                size: 30.h,
                              ),
                            ),
                          ),
                          SizedBox(width: 20.w),
                          Flexible(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Out of delivery",
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  "The Order is out of delivery now expected to reach by today",
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    color: Colors.grey,
                                  ),
                                ),
                                if ((model.status == OrderStatus.shipped &&
                                    model.status == OrderStatus.delivered))
                                  Text(
                                    shippedAt,
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: Colors.black.withOpacity(0.8),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 40.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 70.h,
                            width: 90.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: model.status == OrderStatus.delivered
                                  ? AppColors.appDarkColor
                                  : Colors.grey.shade500,
                            ),
                            child: Center(
                              child: Icon(
                                Iconsax.truck,
                                color: Colors.white,
                                size: 30.h,
                              ),
                            ),
                          ),
                          SizedBox(width: 20.w),
                          Flexible(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Order Delivered",
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  "the Order has been delivered and loaded to respected pipe",
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    color: Colors.grey,
                                  ),
                                ),
                                if (model.status == OrderStatus.delivered)
                                  Text(
                                    deliveredAt,
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: Colors.black.withOpacity(0.8),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30.h),
                      Visibility(
                        visible: model.driverId != "" && model.driverId != null,
                        child: ListTile(
                          leading: Icon(Icons.person_2_outlined, size: 30.h),
                          title: Text(
                            orderData?["driverName"] ?? "",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.sp,
                              color: Colors.black,
                            ),
                          ),
                          trailing: SizedBox(
                            width: 120.w,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ScaleButton(
                                  onTap: () {
                                    final no = orderData?["driverPhone"] ?? "";
                                    if (no != null) {
                                      _makePhoneCall(no);
                                    }
                                  },
                                  child: const Icon(Iconsax.call),
                                ),
                                SizedBox(width: 30.w),
                                ScaleButton(
                                  onTap: () {
                                    final no = orderData?["driverPhone"] ?? "";
                                    if (no != null) {
                                      _openSMSApp(no);
                                    }
                                  },
                                  child: const Icon(Iconsax.message),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.start,
                        //   crossAxisAlignment: CrossAxisAlignment.center,
                        //   children: [
                        //     Icon(
                        //       Icons.person_2_outlined,
                        //       size: 30.h,
                        //     ),
                        //     SizedBox(
                        //       width: 20.w,
                        //     ),
                        //     Column(
                        //       mainAxisAlignment: MainAxisAlignment.center,
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       children: [
                        //         Text(
                        //           orderData?["driverName"] ?? "",
                        //           style: TextStyle(
                        //             fontWeight: FontWeight.bold,
                        //             fontSize: 18.sp,
                        //             color: Colors.black,
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //     SizedBox(
                        //       width: 20.w,
                        //     ),
                        //     Row(
                        //       mainAxisAlignment: MainAxisAlignment.start,
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       children: [
                        //         IconButton(
                        //           onPressed: () {
                        //             final no = orderData?["driverPhone"] ?? "";
                        //             if (no != null) {
                        //               makePhoneCall(no);
                        //             }
                        //           },
                        //           icon: const Icon(Iconsax.call),
                        //         ),
                        //         SizedBox(
                        //           width: 10.w,
                        //         ),
                        //         const Icon(
                        //           Iconsax.message,
                        //         )
                        //       ],
                        //     )
                        //   ],
                        // ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

capitalizeFirstLetter(String input) {
  if (input.isEmpty) return input;
  return input[0].toUpperCase() + input.substring(1);
}
