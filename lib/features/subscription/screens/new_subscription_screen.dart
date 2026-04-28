import 'dart:developer';
import 'dart:io';
import 'dart:ui';

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
import 'package:jal_seva/common/enum.dart';
import 'package:jal_seva/common/models/address_model.dart';
import 'package:jal_seva/features/auth/services/auth_services.dart';
import 'package:jal_seva/features/profile/screens/saved_address.dart';
import 'package:jal_seva/features/subscription/model/subscription_model.dart';
import 'package:jal_seva/features/wallet/model/transection_model.dart';
import 'package:jal_seva/routing/routes.dart';
import 'package:jal_seva/utils.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class NewSubscriptionScreen extends StatefulWidget {
  const NewSubscriptionScreen({super.key});

  @override
  State<NewSubscriptionScreen> createState() => _NewOrderScreenStateState();
}

class _NewOrderScreenStateState extends State<NewSubscriptionScreen> {
  String? addressId;
  int daycount = 0;
  double subscriptionFee = 0.0;

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
  ValueNotifier<int?> quantityNotifier = ValueNotifier<int?>(0);
  ValueNotifier<int?> totalChargeNotifier = ValueNotifier<int?>(0);
  ValueNotifier<Plan?> planNotifier = ValueNotifier<Plan?>(null);
  AddressModel? _addressModel;
  TextEditingController time = TextEditingController();
  Map<String, int> plan = {};
  DateTime? startDate;
  DateTime? endDate;
  List<DateTime> alternateDates = [];
  final ValueNotifier<TxnPaymentMethod> selectedPaymentMethod =
      ValueNotifier<TxnPaymentMethod>(TxnPaymentMethod.wallet);

  fetchAddress() async {
    var r = await addressesCollection.doc(addressId).get();

    if (r.exists && r.data() != null) {
      _addressModel = AddressModel.fromMap(r.data()!);
      log('move in new subscription screen');
    } else {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      var c = await addressesCollection
          .where('uid', isEqualTo: uid)
          .count()
          .get();
      if ((c.count ?? 0) > 0) {
        _showChangeAddressModal();
        log("moved to _showChangeAddressModal");
      } else {
        if (mounted) {
          context.pop();
          context.push(Routes.newAddress.path);
          log("moved to new address screen");
        }
        return;
      }
    }

    setState(() {});
  }

  Future<void> _selectDateRange(BuildContext context) async {
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2024),
      lastDate: DateTime(2100),
      initialDateRange: startDate != null && endDate != null
          ? DateTimeRange(start: startDate!, end: endDate!)
          : null,
    );

    if (picked != null) {
      setState(() {
        startDate = picked.start;
        endDate = picked.end;

        // Generate all dates between startDate and endDate
        alternateDates.clear(); // Clear existing data
        DateTime currentDate = startDate!;
        while (!currentDate.isAfter(endDate!)) {
          alternateDates.add(currentDate);
          currentDate = currentDate.add(
            const Duration(days: 1),
          ); // Move to the next day
        }
      });
    }
  }

  Future<void> _selectAlternateDates(BuildContext context) async {
    final List<DateTime>? pickedDates = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MultiDatePicker()),
    );

    if (pickedDates != null && pickedDates.isNotEmpty) {
      setState(() {
        alternateDates.clear();
        alternateDates = pickedDates; // Update your main list
      });
    }
  }

  // Function to select alternate dates

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
            Text.rich(
              TextSpan(
                text: "Service charge",
                children: const [
                  TextSpan(
                    text: " : ₹ 100",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              style: TextStyle(fontSize: 18.sp),
            ),
            ValueListenableBuilder(
              valueListenable: planNotifier,
              builder: (context, plan, _) {
                return ValueListenableBuilder(
                  valueListenable: addressTypeNotifier,
                  builder: (context, type, _) {
                    return ValueListenableBuilder(
                      valueListenable: quantityNotifier,
                      builder: (context, quantity, _) {
                        bool value =
                            ((quantity ?? 0) > 0) &&
                            plan != null &&
                            type != null;
                        return AnimatedCrossFade(
                          firstChild: SizedBox(width: double.infinity),
                          secondChild: SizedBox(
                            child: Text.rich(
                              TextSpan(
                                text: "Vehicle Quantity",
                                children: [
                                  TextSpan(
                                    text: " : $quantity ${"Litres"}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
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
                    );
                  },
                );
              },
            ),
            ValueListenableBuilder(
              valueListenable: planNotifier,
              builder: (context, plan, _) {
                return ValueListenableBuilder(
                  valueListenable: addressTypeNotifier,
                  builder: (context, type, _) {
                    return ValueListenableBuilder(
                      valueListenable: quantityNotifier,
                      builder: (context, q, _) {
                        bool value =
                            ((q ?? 0) > 0) && plan != null && type != null;
                        return AnimatedCrossFade(
                          firstChild: const SizedBox(width: double.infinity),
                          secondChild: SizedBox(
                            width: double.infinity,
                            child: Text.rich(
                              TextSpan(
                                text: "Charge",
                                children: [
                                  TextSpan(
                                    text:
                                        " :  ${((((q ?? 0) * 5) + ((type ?? false) ? 5 : 0)) * ((plan == Plan.daily || plan == Plan.alternate ? alternateDates.length : daycount)))} rupee",
                                    // " : ${(q ?? 0) * 5}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
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
                    );
                  },
                );
              },
            ),
            const Divider(color: Colors.grey),
            ValueListenableBuilder(
              valueListenable: planNotifier,
              builder: (context, plan, _) {
                return Row(
                  children: [
                    Text("To Pay", style: TextStyle(fontSize: 18.sp)),
                    ValueListenableBuilder(
                      valueListenable: quantityNotifier,
                      builder: (context, quantity, _) {
                        return ValueListenableBuilder(
                          valueListenable: addressTypeNotifier,
                          builder: (context, type, _) {
                            return ValueListenableBuilder(
                              valueListenable: quantityNotifier,
                              builder: (context, quantity, _) {
                                var payment =
                                    ((((quantity ?? 0) * 5) +
                                            ((type ?? false) ? 5 : 0)) *
                                        ((plan == Plan.daily ||
                                                plan == Plan.alternate
                                            ? alternateDates.length
                                            : daycount))) +
                                    2.33;
                                totalChargeNotifier.value = payment.toInt();

                                return Text(
                                  quantity != 0 ? "₹ $payment" : "0.0",
                                  // "${((((quantity ?? 0) * 5) + ((type ?? false) ? 5 : 0)) * ((plan == Plan.daily || plan == Plan.alternate ? alternateDates.length : daycount))) + 2.33}",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: 15.h),
            DynamicButton.fromText(
              text: "Subscribe",
              onPressed: () async {
                if (addressTypeNotifier.value == null) {
                  Fluttertoast.showToast(msg: 'Select Delivery type first');
                  return;
                }

                if ((quantityNotifier.value ?? 0) < 1) {
                  Fluttertoast.showToast(msg: 'Enter quantity first');
                  return;
                }
                _showPaymentModel(totalChargeNotifier.value ?? 0);
              },
            ),
            SizedBox(height: MediaQuery.paddingOf(context).bottom + 5),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: AppColors.appDarkColor,
        title: Text(
          'New Subscription',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Icon(Icons.arrow_back, size: 28.h, color: Colors.white),
        ),
      ),
      body: SizedBox.fromSize(
        size: MediaQuery.sizeOf(context),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: SizedBox.fromSize(
            size: MediaQuery.sizeOf(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Deliver To",
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
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text('10-20 mins'),
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
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text("Instant"),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 10),
                Text(
                  "Subscription Type",
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                ValueListenableBuilder(
                  valueListenable: planNotifier,
                  builder: (context, value, _) {
                    return Row(
                      children: [
                        Expanded(
                          child: ScaleButton(
                            scale: .98,
                            onTap: () async {
                              planNotifier.value = Plan.daily;
                              await _selectDateRange(context);
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 400),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: value == Plan.daily
                                    ? AppColors.buttonColor.withOpacity(.2)
                                    : null,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  width: value == Plan.daily ? 2 : .5,
                                  strokeAlign: BorderSide.strokeAlignOutside,
                                  color: value == Plan.daily
                                      ? AppColors.buttonColor
                                      : Colors.grey,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Daily",
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 22),
                        Expanded(
                          child: ScaleButton(
                            scale: .98,
                            onTap: () async {
                              planNotifier.value = Plan.alternate;
                              _selectAlternateDates(context);

                              // show datePiker
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 400),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: value == Plan.alternate
                                    ? AppColors.buttonColor.withOpacity(.2)
                                    : null,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  width: value == Plan.alternate ? 2 : .5,
                                  strokeAlign: BorderSide.strokeAlignOutside,
                                  color: value == Plan.alternate
                                      ? AppColors.buttonColor
                                      : Colors.grey,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Alternate",
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 22),
                        Expanded(
                          child: ScaleButton(
                            scale: .98,
                            onTap: () async {
                              planNotifier.value = Plan.weekly;
                              var r = await showCupertinoModalPopup(
                                barrierDismissible: true,
                                context: context,
                                builder: (context) =>
                                    WeeklyDetails(cPlan: plan),
                              );
                              quantityNotifier.value = 0;
                              daycount = 0;

                              for (var i in (r as Map<String, int>).values) {
                                i > 0 ? daycount++ : daycount += 0;
                                quantityNotifier.value =
                                    (quantityNotifier.value ?? 0) + i;
                              }

                              plan = r;

                              // quantityNotifier.value =
                              //     (r as Map<String, int>).values.map(toElement);
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 400),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: value == Plan.weekly
                                    ? AppColors.buttonColor.withOpacity(.2)
                                    : null,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  width: value == Plan.weekly ? 2 : .5,
                                  strokeAlign: BorderSide.strokeAlignOutside,
                                  color: value == Plan.weekly
                                      ? AppColors.buttonColor
                                      : Colors.grey,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Weekly",
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(height: 15.h),
                ValueListenableBuilder(
                  valueListenable: planNotifier,
                  builder: (context, plan, _) {
                    return ValueListenableBuilder(
                      valueListenable: quantityNotifier,
                      builder: (context, value, _) {
                        bool pll =
                            (plan == Plan.daily || plan == Plan.alternate);
                        return AnimatedCrossFade(
                          firstChild: const SizedBox(),
                          secondChild: SizedBox(
                            child: SfSliderTheme(
                              data: const SfSliderThemeData(thumbRadius: 10),
                              child: SfSlider(
                                max: 50.0,
                                stepSize: 1,
                                thumbIcon: Container(
                                  alignment: Alignment.center,
                                  // child: Text(
                                  //   ((value)!.toInt() /
                                  //           alternateDates.length)
                                  //       .toString(),
                                  //   style: const TextStyle(
                                  //       color: Colors.white),
                                  //   textAlign: TextAlign.center,
                                  // ),
                                ),
                                value:
                                    (value)!.toInt() /
                                    (10 * alternateDates.length),
                                onChanged: (dynamic aa) {
                                  setState(() {
                                    quantityNotifier.value =
                                        num.parse("$aa").toInt() *
                                        10 *
                                        alternateDates.length;
                                  });
                                },
                              ),
                            ),
                          ),
                          crossFadeState: pll == true
                              ? CrossFadeState.showSecond
                              : CrossFadeState.showFirst,
                          duration: const Duration(milliseconds: 400),
                          sizeCurve: Curves.fastEaseInToSlowEaseOut,
                          firstCurve: Curves.fastEaseInToSlowEaseOut,
                          secondCurve: Curves.fastEaseInToSlowEaseOut,
                        );
                      },
                    );
                  },
                ),
                // const SizedBox(height: 10),
                // Text(
                //   "Delivery Type",
                //   style: TextStyle(
                //     fontSize: 15,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                // SizedBox(height: 10),
                // CustomTextField(
                //   iconData: Iconsax.bucket,
                //   removeFocusOutside: true,
                //   isNumber: true,
                //   onChanged: (value) {
                //     quantityNotifier.value = int.tryParse(value);
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
          onVerticalDragEnd: (content) {
            if (content.primaryVelocity != null &&
                content.primaryVelocity! > 0) {
              Navigator.of(context).pop();
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
                    Padding(
                      padding: const EdgeInsets.only(left: 22),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          "Select Delivery Address",
                          style: TextStyle(
                            fontSize: 15.sp,
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

  _showPaymentModel(int amount) async {
    showCupertinoModalPopup(
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
              height: MediaQuery.sizeOf(context).height * .40,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    SizedBox(height: 15.h),
                    Center(
                      child: Container(
                        height: 5.h,
                        width: 30.w,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    ValueListenableBuilder<TxnPaymentMethod>(
                      valueListenable: selectedPaymentMethod,
                      builder: (context, value, child) {
                        return Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                              ),
                              child: Material(
                                child: RadioListTile<TxnPaymentMethod>(
                                  title: Text(
                                    "Jal-Seva Wallet",
                                    style: TextStyle(
                                      fontSize: 17.sp,
                                      color: Colors.black,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "View Balance",
                                    style: TextStyle(
                                      color: AppColors.appDarkColor,
                                    ),
                                  ),
                                  value: TxnPaymentMethod.wallet,
                                  groupValue: value,
                                  onChanged: (TxnPaymentMethod? newValue) {
                                    selectedPaymentMethod.value = newValue!;
                                  },
                                  controlAffinity: ListTileControlAffinity
                                      .trailing, // Place radio button at trailing
                                ),
                              ),
                            ),
                            SizedBox(height: 10.h),

                            SizedBox(height: 10.h),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                              ),
                              child: Material(
                                child: RadioListTile<TxnPaymentMethod>(
                                  title: Text(
                                    "Card Payment",
                                    style: TextStyle(
                                      fontSize: 17.sp,
                                      color: Colors.black,
                                    ),
                                  ),
                                  value: TxnPaymentMethod.razorpay,
                                  groupValue: value,
                                  activeColor: Colors.green,
                                  onChanged: (TxnPaymentMethod? newValue) {
                                    selectedPaymentMethod.value = newValue!;
                                  },
                                  controlAffinity: ListTileControlAffinity
                                      .trailing, // Place radio button at trailing
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    SizedBox(height: 20.h),
                    DynamicButton.fromText(
                      text: "Make Payment",
                      onPressed: () async {
                        // showLoading(context);

                        String uid = FirebaseAuth.instance.currentUser!.uid;
                        var ref = subscriptionsCollection.doc(uid);
                        DateTime now = DateTime.now();
                        alternateDates.sort();

                        SubscriptionModel model = SubscriptionModel(
                          id: ref.id,
                          uid: uid,
                          address: _addressModel!,
                          planMap: plan,
                          plan: planNotifier.value ?? Plan.weekly,
                          createdAt: now,
                          status: SubscriptionStatus.active,
                          reNewDate: planNotifier.value == Plan.weekly
                              ? now.add(const Duration(days: 7))
                              : alternateDates.last,
                          pausedAt: now,
                        );

                        if (context.mounted) {
                          if (selectedPaymentMethod.value ==
                              TxnPaymentMethod.razorpay) {
                          } else if (selectedPaymentMethod.value ==
                              TxnPaymentMethod.wallet) {
                          } else {
                            final refe = users.doc(uid);
                            final snap = await refe.get();

                            if (snap.exists) {
                              final data = snap.data()!;
                              double balance = double.parse(data["balance"]);
                              if (balance <= amount) {
                                Fluttertoast.showToast(
                                  msg: "In sufficient balance",
                                );
                                return;
                              } else {
                                balance = balance - amount;
                                if (context.mounted) {
                                  showLoading(context);
                                  try {
                                    await refe.update({
                                      "balance": balance.toString(),
                                    });
                                    await ref.set(model.toMap());
                                    context.push(Routes.subscribed.path);
                                  } catch (e) {
                                    log(e.toString());
                                  }

                                  context.pop();

                                  return;
                                }
                              }
                            }
                          }
                        }
                      },
                    ),
                    SizedBox(height: 10.h),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class WeeklyDetails extends StatefulWidget {
  const WeeklyDetails({super.key, required this.cPlan});

  @override
  State<WeeklyDetails> createState() => _WeeklyDetailsState();
  final Map<String, int> cPlan;
}

class _WeeklyDetailsState extends State<WeeklyDetails> {
  String selected = "Sunday";
  late Map<String, int> plan;

  @override
  void initState() {
    super.initState();
    plan = widget.cPlan;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(
          bottom: MediaQuery.paddingOf(context).bottom + 10,
          top: 10,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.only(left: 22.w),
              child: Text(
                'Select plan details.',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w900),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 100,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                scrollDirection: Axis.horizontal,
                children: [
                  ...[
                    "Sunday",
                    "Monday",
                    "Tuesday",
                    "Wednesday",
                    "Thursday",
                    "Friday ",
                    "Saturday",
                  ].map((e) {
                    return ScaleButton(
                      onTap: selected == e
                          ? null
                          : () {
                              setState(() {
                                selected = e;
                              });
                            },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        padding: const EdgeInsets.all(20),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2.5,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: selected == e
                              ? AppColors.buttonColor.withOpacity(.2)
                              : Colors.white,
                          border: Border.all(
                            color: selected == e
                                ? AppColors.buttonColor
                                : Colors.grey.withOpacity(.5),
                            width: selected == e ? 2.5 : 1,
                            strokeAlign: BorderSide.strokeAlignOutside,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              e.substring(0, 3),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            AnimatedCrossFade(
                              firstChild: const SizedBox(height: 0),
                              secondChild: SizedBox(
                                child: Text("${(plan[e] ?? 0)}  sq m."),
                              ),
                              crossFadeState: plan[e] == null
                                  ? CrossFadeState.showFirst
                                  : CrossFadeState.showSecond,
                              duration: const Duration(milliseconds: 400),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 120),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Theme(
                data: ThemeData(
                  colorScheme: ColorScheme.fromSeed(
                    seedColor: Colors.black,
                    primary: Colors.black,
                  ),
                ),
                child: SfSliderTheme(
                  data: const SfSliderThemeData(thumbRadius: 30),
                  child: SfSlider(
                    max: 50.0,
                    stepSize: 1,
                    thumbIcon: Container(
                      alignment: Alignment.center,
                      child: Text(
                        ((plan[selected] ?? 0).toInt()).toString(),
                        style: const TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    value: (plan[selected] ?? 0) / 10,
                    onChanged: (dynamic mm) {
                      setState(() {
                        plan[selected] = num.parse("${(mm)}").toInt() * 10;
                        if (plan[selected] == 0) {
                          plan.remove(selected);
                        }
                      });
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 60),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: DynamicButton.fromText(
                text: "Okey",
                onPressed: () {
                  context.pop(plan);
                },
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class MultiDatePicker extends StatefulWidget {
  const MultiDatePicker({super.key});

  @override
  _MultiDatePickerState createState() => _MultiDatePickerState();
}

class _MultiDatePickerState extends State<MultiDatePicker> {
  List<DateTime> alternateDates = []; // List to store selected dates

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Alternate Dates")),
      body: Column(
        children: [
          Expanded(
            child: SfDateRangePicker(
              selectionMode: DateRangePickerSelectionMode.multiple,
              onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                setState(() {
                  if (args.value is List<DateTime>) {
                    alternateDates = args.value;
                  }
                });
              },
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            "Select Dates",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: alternateDates.length,
              itemBuilder: (context, index) {
                final date = alternateDates[index];
                return ListTile(
                  title: Text('${date.day}-${date.month}-${date.year}'),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context, alternateDates); // Return selected dates
              },
              child: Text("Done"),
            ),
          ),
        ],
      ),
    );
  }
}
