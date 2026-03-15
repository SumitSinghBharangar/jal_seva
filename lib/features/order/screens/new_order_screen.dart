import 'dart:ui';
import 'package:jal_seva/features/profile/screens/saved_address.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:jal_seva/common/app_colors.dart';
import 'package:jal_seva/common/buttons/dynamic_button.dart';
import 'package:jal_seva/common/buttons/scale_button.dart';
import 'package:jal_seva/common/constants/app_collections.dart';
import 'package:jal_seva/common/models/address_model.dart';
import 'package:jal_seva/features/auth/services/auth_services.dart';
import 'package:jal_seva/routing/routes.dart';

import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_core/theme.dart';

class NewOrderScreen extends StatefulWidget {
  const NewOrderScreen({super.key});

  @override
  State<NewOrderScreen> createState() => _NewOrderScreenState();
}

class _NewOrderScreenState extends State<NewOrderScreen> {
  String? addressId;

  // final ValueNotifier<PaymentMethod> selectedPaymentMethod =
  //     ValueNotifier<PaymentMethod>(PaymentMethod.gibiliWallet);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var p = Provider.of<AuthServices>(context, listen: false);
      addressId = p.primaryAdress;
      fetchAddress();
    });
  }

  ValueNotifier<bool?> addressTypeNotifier = ValueNotifier<bool?>(null);
  ValueNotifier<int> quantityNotifier = ValueNotifier<int>(0);

  AddressModel? _addressModel;
  bool isPaid = false;

  fetchAddress() async {
    var r = await addressesCollection.doc(addressId).get();

    if (r.exists && r.data() != null) {
      _addressModel = AddressModel.fromMap(r.data()!);
    } else {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      var c = await addressesCollection
          .where('uid', isEqualTo: uid)
          .count()
          .get();
      if ((c.count ?? 0) > 0) {
        _showChangeAddressModal();
      } else {
        if (mounted) {
          context.pop();
          context.push(Routes.newAddress.path);
        }
        return;
      }
    }

    setState(() {});
  }

  // final paymentConfig = PaymentConfig(
  //   publishableApiKey: 'pk_test_r6eZg85QyduWZ7PNTHT56BFvZpxJgNJ2PqPMDoXA',
  //   amount: 1000, // SAR 1
  //   description: 'order #1324',
  //   metadata: {'size': '250g'},
  //   creditCard: CreditCardConfig(saveCard: false, manual: false),
  //   applePay: ApplePayConfig(
  //       merchantId: 'merchant.mysr.fghurayri',
  //       label: 'Blue Coffee Beans',
  //       manual: false),
  // );

  // void onPaymentResult(result) {
  //   if (result is PaymentResponse) {
  //     Fluttertoast.showToast(msg: result.status.name);
  //     switch (result.status) {
  //       case PaymentStatus.paid:
  //         context.push(Routes.orderPlaced.path);

  //         break;
  //       case PaymentStatus.failed:
  //         Fluttertoast.showToast(
  //           msg: AppLocalizations.of(context)!.yourPaymentFailedTryAgain,
  //         );
  //         Navigator.pop(context);
  //         break;
  //       case PaymentStatus.authorized:
  //         // handle authorized.
  //         break;
  //       default:
  //     }
  //     return;
  //   }
  //   if (result is ApiError) {}
  //   if (result is AuthError) {}
  //   if (result is ValidationError) {}
  //   if (result is PaymentCanceledError) {}
  //   if (result is UnprocessableTokenError) {}
  //   if (result is TimeoutError) {}
  //   if (result is NetworkError) {}
  //   if (result is UnspecifiedError) {}
  // }

  @override
  void dispose() {
    addressTypeNotifier.dispose();
    quantityNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var w = context.watch<AuthServices>();

    return Scaffold(
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(22),
        padding: const EdgeInsets.symmetric(horizontal: 11),
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(width: .5, color: Colors.grey)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 11),
            ValueListenableBuilder(
              valueListenable: quantityNotifier,
              builder: (context, q, _) {
                bool value = (q) > 0;
                return AnimatedCrossFade(
                  firstChild: const SizedBox(width: double.infinity),
                  secondChild: SizedBox(
                    width: double.infinity,
                    child: Text.rich(
                      TextSpan(
                        text: "Vehicle Capacity",
                        children: [
                          TextSpan(
                            text: " : ${(q) * 10} ${"sq m"}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  crossFadeState: value == true
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 400),
                  sizeCurve: Curves.fastEaseInToSlowEaseOut,
                  firstCurve: Curves.fastEaseInToSlowEaseOut,
                  secondCurve: Curves.fastEaseInToSlowEaseOut,
                );
              },
            ),
            Text.rich(
              TextSpan(
                text: "Service Charge",
                children: const [
                  TextSpan(
                    text: " : 2.33 SAR",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              style: TextStyle(fontSize: 18.sp),
            ),
            ValueListenableBuilder(
              valueListenable: addressTypeNotifier,
              builder: (context, value, _) {
                return AnimatedCrossFade(
                  firstChild: const SizedBox(width: double.infinity),
                  secondChild: SizedBox(
                    width: double.infinity,
                    child: Text.rich(
                      TextSpan(
                        text: "Express Charge",
                        children: const [
                          TextSpan(
                            text: " : 5 SAR",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      style: TextStyle(fontSize: 18.sp),
                    ),
                  ),
                  crossFadeState: value == true
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 400),
                  sizeCurve: Curves.fastEaseInToSlowEaseOut,
                  firstCurve: Curves.fastEaseInToSlowEaseOut,
                  secondCurve: Curves.fastEaseInToSlowEaseOut,
                );
              },
            ),
            ValueListenableBuilder(
              valueListenable: quantityNotifier,
              builder: (context, q, _) {
                bool value = (q) > 0;
                return AnimatedCrossFade(
                  firstChild: const SizedBox(width: double.infinity),
                  secondChild: SizedBox(
                    width: double.infinity,
                    child: Text.rich(
                      TextSpan(
                        text: "Charge",
                        children: [
                          TextSpan(
                            text: " : ${(q) * 5} SAR",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  crossFadeState: value == true
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 400),
                  sizeCurve: Curves.fastEaseInToSlowEaseOut,
                  firstCurve: Curves.fastEaseInToSlowEaseOut,
                  secondCurve: Curves.fastEaseInToSlowEaseOut,
                );
              },
            ),
            SizedBox(height: 22.h),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("To Pay"),
                      ValueListenableBuilder(
                        valueListenable: addressTypeNotifier,
                        builder: (context, type, _) {
                          return ValueListenableBuilder(
                            valueListenable: quantityNotifier,
                            builder: (context, quantity, _) {
                              var amount =
                                  (quantity * 5) +
                                  (type == true ? 5 : 0) +
                                  2.33;

                              return Text(
                                "$amount SAR",
                                // "${((quantity) * 5) + (type == true ? 5 : 0) + 2.33}\$",
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: DynamicButton.fromText(
                    text: "Make Payment",
                    onPressed: () async {
                      if (addressTypeNotifier.value == null) {
                        Fluttertoast.showToast(
                          msg: "Select Delivery type first",
                        );
                        return;
                      }

                      if ((quantityNotifier.value) < 1) {
                        Fluttertoast.showToast(msg: "Enter quantity first");
                        return;
                      }

                      // _showPaymentModel();
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.paddingOf(context).bottom + 5),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: AppColors.appDarkColor,
        title: Text(
          "New Order",
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
      body: SizedBox.fromSize(
        size: MediaQuery.sizeOf(context),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 21.w),
          child: SizedBox.fromSize(
            size: MediaQuery.sizeOf(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Delivery Address",
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        _showChangeAddressModal();
                      },
                      child: Text("Change"),
                    ),
                  ],
                ),
                Builder(
                  builder: (context) {
                    if (_addressModel == null) {
                      return Container(
                        height: 119,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      );
                    }

                    return AddressCard(
                      model: _addressModel!,
                      isPrimary: addressId == w.primaryAdress,
                    );
                  },
                ),
                const SizedBox(height: 20),
                Text(
                  "Delivery Type",
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                ValueListenableBuilder(
                  valueListenable: addressTypeNotifier,
                  builder: (context, value, _) {
                    return Row(
                      children: [
                        Expanded(
                          child: ScaleButton(
                            scale: .98,
                            onTap: () {
                              addressTypeNotifier.value = false;
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 400),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: value == false
                                    ? AppColors.buttonColor.withOpacity(.2)
                                    : null,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  width: value == false ? 2 : .5,
                                  strokeAlign: BorderSide.strokeAlignOutside,
                                  color: value == false
                                      ? AppColors.buttonColor
                                      : Colors.grey,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Normal Delivery",
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text("10-20 mins"),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 22),
                        Expanded(
                          child: ScaleButton(
                            scale: .98,
                            onTap: () {
                              addressTypeNotifier.value = true;
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 400),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: value == true
                                    ? AppColors.buttonColor.withOpacity(.2)
                                    : null,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  width: value == true ? 2 : .5,
                                  strokeAlign: BorderSide.strokeAlignOutside,
                                  color: value == true
                                      ? AppColors.buttonColor
                                      : Colors.grey,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Express Delivery",
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text("instant"),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(height: 20.h),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 7.h,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Schedule"),
                      SizedBox(height: 5.h),
                      Text(
                        "Order will arrive based on the time you set.",
                        style: TextStyle(color: Colors.grey, fontSize: 13.sp),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),

                Text(
                  "Vehicle Capacity",
                  style: TextStyle(
                    fontSize: 19.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                ValueListenableBuilder(
                  valueListenable: quantityNotifier,
                  builder: (context, value, _) {
                    return Theme(
                      data: ThemeData(
                        colorScheme: ColorScheme.fromSeed(
                          seedColor: AppColors.appDarkColor,
                          primary: AppColors.appDarkColor,
                        ),
                      ),
                      child: SfSliderTheme(
                        data: const SfSliderThemeData(thumbRadius: 10),
                        child: SfSlider(
                          max: 50.0,
                          stepSize: 1,
                          thumbIcon: Container(
                            alignment: Alignment.center,
                            // child: Text(
                            //   ((value).toInt() * 10).toString(),
                            //   style: const TextStyle(color: Colors.white),
                            //   textAlign: TextAlign.center,
                            // ),
                          ),
                          value: value,
                          onChanged: (dynamic a) {
                            setState(() {
                              quantityNotifier.value = num.parse("$a").toInt();
                            });
                          },
                        ),
                      ),
                    );
                  },
                ),
                // CustomTextField(
                //   iconData: Iconsax.bucket,
                //   removeFocusOutside: true,
                //   isNumber: true,
                //   onChanged: (value) {
                //     quantityNotifier.value = int.tryParse(value) ?? 0;
                //   },
                //   hintText: "Enter Quantity (sq. meter)",
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showChangeAddressModal() {
    var w = Provider.of<AuthServices>(context, listen: false);

    String uid = FirebaseAuth.instance.currentUser!.uid;
    showCupertinoModalPopup(
      barrierDismissible: false,
      context: context,
      builder: (context) {
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
              height: MediaQuery.sizeOf(context).height * .85,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              ),
              child: Scaffold(
                floatingActionButton: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: GestureDetector(
                    onTap: () {
                      context.push(Routes.newAddress.path);
                    },
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.buttonColor.withOpacity(.5),
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 20,
                              blurStyle: BlurStyle.outer,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Iconsax.add,
                          color: Colors.black,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ),
                body: Column(
                  children: [
                    const SizedBox(height: 12),
                    Container(
                      width: 50,
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(.3),
                        borderRadius: BorderRadius.circular(122),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Padding(
                      padding: EdgeInsets.only(left: 22),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          "Select Delivery Address",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: FirestoreListView.separated(
                        query: addressesCollection.where('uid', isEqualTo: uid),
                        padding: EdgeInsets.only(
                          left: 22,
                          right: 22,
                          bottom: MediaQuery.paddingOf(context).bottom + 40,
                        ),
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 20),
                        itemBuilder: (context, doc) {
                          AddressModel model = AddressModel.fromMap(doc.data());

                          return AddressCard(
                            onTap: () {
                              context.pop();
                              addressId = model.id;
                              setState(() {});
                              fetchAddress();
                            },
                            isPrimary: w.primaryAdress == model.id,
                            model: model,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // _showPaymentModel() async {
  //   showCupertinoModalPopup(
  //     context: context,
  //     builder: (context) {
  //       return GestureDetector(
  //         onVerticalDragEnd: (details) {
  //           if (details.primaryVelocity != null &&
  //               details.primaryVelocity! > 0) {
  //             Navigator.pop(context);
  //           }
  //         },
  //         child: ClipRRect(
  //           borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
  //           child: Container(
  //             height: MediaQuery.sizeOf(context).height * .40,
  //             decoration: const BoxDecoration(
  //               color: Colors.white,
  //               borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
  //             ),
  //             child: Padding(
  //               padding: EdgeInsets.symmetric(horizontal: 20.w),
  //               child: Column(
  //                 children: [
  //                   SizedBox(height: 15.h),
  //                   Center(
  //                     child: Container(
  //                       height: 5.h,
  //                       width: 30.w,
  //                       decoration: BoxDecoration(
  //                         color: Colors.grey,
  //                         borderRadius: BorderRadius.circular(20),
  //                       ),
  //                     ),
  //                   ),
  //                   SizedBox(height: 20.h),

  //                   ValueListenableBuilder<PaymentMethod>(
  //                     valueListenable: selectedPaymentMethod,
  //                     builder: (context, value, child) {
  //                       return Column(
  //                         children: [
  //                           Container(
  //                             decoration: BoxDecoration(
  //                               border: Border.all(color: Colors.grey),
  //                             ),
  //                             child: Material(
  //                               child: RadioListTile<PaymentMethod>(
  //                                 title: Text(
  //                                   "Gibili Wallet",
  //                                   style: TextStyle(
  //                                     fontSize: 17.sp,
  //                                     color: Colors.black,
  //                                   ),
  //                                 ),
  //                                 subtitle: Text(
  //                                   "View Balance",
  //                                   style: TextStyle(
  //                                     color: AppColors.appDarkColor,
  //                                   ),
  //                                 ),
  //                                 value: PaymentMethod.gibiliWallet,
  //                                 groupValue: value,
  //                                 onChanged: (PaymentMethod? newValue) {
  //                                   selectedPaymentMethod.value = newValue!;
  //                                 },
  //                                 controlAffinity: ListTileControlAffinity
  //                                     .trailing, // Place radio button at trailing
  //                               ),
  //                             ),
  //                           ),
  //                           SizedBox(height: 10.h),
  //                           if (Platform.isIOS)
  //                             Container(
  //                               decoration: BoxDecoration(
  //                                 border: Border.all(color: Colors.grey),
  //                               ),
  //                               child: Material(
  //                                 child: RadioListTile<PaymentMethod>(
  //                                   title: Text(
  //                                     l?.applePay ?? "Apple Pay",
  //                                     style: TextStyle(
  //                                       fontSize: 17.sp,
  //                                       color: Colors.black,
  //                                     ),
  //                                   ),
  //                                   value: PaymentMethod.applePay,
  //                                   groupValue: value,
  //                                   activeColor: Colors.green,
  //                                   onChanged: (PaymentMethod? newValue) {
  //                                     selectedPaymentMethod.value = newValue!;
  //                                   },
  //                                   controlAffinity: ListTileControlAffinity
  //                                       .trailing, // Place radio button at trailing
  //                                 ),
  //                               ),
  //                             ),
  //                           SizedBox(height: 10.h),
  //                           Container(
  //                             decoration: BoxDecoration(
  //                               border: Border.all(color: Colors.grey),
  //                             ),
  //                             child: Material(
  //                               child: RadioListTile<PaymentMethod>(
  //                                 title: Text(
  //                                   l?.cardPayment ?? "Card Payment",
  //                                   style: TextStyle(
  //                                     fontSize: 17.sp,
  //                                     color: Colors.black,
  //                                   ),
  //                                 ),
  //                                 value: PaymentMethod.cardPayment,
  //                                 groupValue: value,
  //                                 activeColor: Colors.green,
  //                                 onChanged: (PaymentMethod? newValue) {
  //                                   selectedPaymentMethod.value = newValue!;
  //                                 },
  //                                 controlAffinity: ListTileControlAffinity
  //                                     .trailing, // Place radio button at trailing
  //                               ),
  //                             ),
  //                           ),
  //                         ],
  //                       );
  //                     },
  //                   ),
  //                   SizedBox(height: 20.h),
  //                   Material(
  //                     child: DynamicButton.fromText(
  //                       text: l?.makePayment ?? "Make Payment",
  //                       onPressed: () async {
  //                         // showLoading(context);

  //                         var ref = ordersCollection.doc();
  //                         String uid = FirebaseAuth.instance.currentUser!.uid;

  //                         var total =
  //                             ((quantityNotifier.value) * 5) +
  //                             (addressTypeNotifier.value == true ? 5 : 0) +
  //                             2.33;

  //                         OrderModel order = OrderModel(
  //                           status: OrderStatus.pending,
  //                           id: ref.id,
  //                           address: _addressModel!,
  //                           isExpressDelivery: addressTypeNotifier.value!,
  //                           quantity: quantityNotifier.value,
  //                           totalCharge: total,
  //                           createdAt: DateTime.now(),
  //                           uid: uid,
  //                           isClosed: false,
  //                           driverId: "",
  //                         );
  //                         final paymentconfig = PaymentConfig(
  //                           publishableApiKey:
  //                               "pk_test_r6eZg85QyduWZ7PNTHT56BFvZpxJgNJ2PqPMDoXA",
  //                           amount: total.toInt() * 100,
  //                           description: ref.id,
  //                         );

  //                         if (context.mounted) {
  //                           if (selectedPaymentMethod.value ==
  //                               PaymentMethod.cardPayment) {
  //                             Navigator.push(
  //                               context,
  //                               CupertinoPageRoute(
  //                                 builder: (context) => CardPaymentScreen(
  //                                   paymentConfig: paymentconfig,
  //                                   onPaymentResult: (result) async {
  //                                     if (result is PaymentResponse) {
  //                                       Fluttertoast.showToast(
  //                                         msg: result.status.name,
  //                                       );
  //                                       switch (result.status) {
  //                                         case PaymentStatus.paid:
  //                                           await ref.set(order.toMap());
  //                                           Fluttertoast.showToast(
  //                                             msg: "Order Placed successfully",
  //                                           );
  //                                           context.push(
  //                                             Routes.orderPlaced.path,
  //                                           );
  //                                           break;
  //                                         case PaymentStatus.failed:
  //                                           Fluttertoast.showToast(
  //                                             msg:
  //                                                 l?.yourPaymentFailedTryAgain ??
  //                                                 "Your Payment failed try again",
  //                                           );
  //                                           Navigator.pop(context);
  //                                           break;
  //                                         case PaymentStatus.authorized:
  //                                           // handle authorized.
  //                                           break;
  //                                         default:
  //                                       }
  //                                       return;
  //                                     }
  //                                     if (result is ApiError) {}
  //                                     if (result is AuthError) {}
  //                                     if (result is ValidationError) {}
  //                                     if (result is PaymentCanceledError) {}
  //                                     if (result is UnprocessableTokenError) {}
  //                                     if (result is TimeoutError) {}
  //                                     if (result is NetworkError) {}
  //                                     if (result is UnspecifiedError) {}
  //                                   },
  //                                 ),
  //                               ),
  //                             );
  //                           } else if (selectedPaymentMethod.value ==
  //                               PaymentMethod.applePay) {
  //                             Navigator.push(
  //                               context,
  //                               CupertinoPageRoute(
  //                                 builder: (context) => ApplepayScreen(
  //                                   paymentConfig: paymentconfig,
  //                                   onPaymentResult: (result) async {
  //                                     if (result is PaymentResponse) {
  //                                       Fluttertoast.showToast(
  //                                         msg: result.status.name,
  //                                       );
  //                                       switch (result.status) {
  //                                         case PaymentStatus.paid:
  //                                           var ref = ordersCollection.doc();
  //                                           await ref.set(order.toMap());
  //                                           context.push(
  //                                             Routes.orderPlaced.path,
  //                                           );

  //                                           break;
  //                                         case PaymentStatus.failed:
  //                                           Fluttertoast.showToast(
  //                                             msg:

  //                                                 "Your Payment failed try again",
  //                                           );
  //                                           Navigator.pop(context);
  //                                           break;
  //                                         case PaymentStatus.authorized:
  //                                           // handle authorized.
  //                                           break;
  //                                         default:
  //                                       }
  //                                       return;
  //                                     }
  //                                     if (result is ApiError) {}
  //                                     if (result is AuthError) {}
  //                                     if (result is ValidationError) {}
  //                                     if (result is PaymentCanceledError) {}
  //                                     if (result is UnprocessableTokenError) {}
  //                                     if (result is TimeoutError) {}
  //                                     if (result is NetworkError) {}
  //                                     if (result is UnspecifiedError) {}
  //                                   },
  //                                 ),
  //                               ),
  //                             );
  //                           } else {
  //                             final userRef = users.doc(uid);
  //                             final snapshot = await userRef.get();

  //                             if (snapshot.exists) {
  //                               final data = snapshot.data()!;
  //                               double balance = double.parse(data["balance"]);
  //                               if (balance <= total) {
  //                                 Fluttertoast.showToast(
  //                                   msg: "Amount not sufficient",
  //                                 );
  //                                 return;
  //                               } else {
  //                                 try {
  //                                   showLoading(context);
  //                                   balance = balance - total;

  //                                   await userRef.update({
  //                                     "balance": balance.toString(),
  //                                   });

  //                                   await ref.set(order.toMap());
  //                                   if (context.mounted) {
  //                                     context.pop();
  //                                     context.go(Routes.orderPlaced.path);
  //                                   }

  //                                   return;
  //                                 } catch (e) {
  //                                   log(e.toString());
  //                                   Fluttertoast.showToast(msg: e.toString());
  //                                 }
  //                               }
  //                             }
  //                           }
  //                         }

  //                         // await ref.set(order.toMap());

  //                         // if (context.mounted) {
  //                         //   context.pop();
  //                         //   Navigator.push(
  //                         //     context,
  //                         //     CupertinoPageRoute(
  //                         //       builder: (context) => PaymentScreen(
  //                         //         paymentConfig: paymentconfig,
  //                         //         onPaymentResult: onPaymentResult,
  //                         //       ),
  //                         //     ),
  //                         //   );
  //                         // context.push(Routes.orderPlaced.path);
  //                         // }
  //                       },
  //                     ),
  //                   ),
  //                   SizedBox(height: 10.h),

  //                   // Consumer<LanguageChangeController>(
  //                   //     builder: (context, languageController, child) {
  //                   //   return DynamicButton.fromText(
  //                   //       text: "Set Language",
  //                   //       onPressed: () {
  //                   //         languageController.changeLanguage(
  //                   //             Locale(selectedLanguage.value.toString()));
  //                   //         Navigator.pop(context);
  //                   //       });
  //                   // })
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
}
