import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:jal_seva/common/app_colors.dart';
import 'package:jal_seva/common/buttons/scale_button.dart';
import 'package:jal_seva/common/constants/app_collections.dart';
import 'package:jal_seva/common/models/address_model.dart';
import 'package:jal_seva/features/auth/services/auth_services.dart';
import 'package:jal_seva/routing/routes.dart';
import 'package:provider/provider.dart';

class SavedAddress extends StatefulWidget {
  const SavedAddress({super.key});

  @override
  State<SavedAddress> createState() => _SavedAddressState();
}

class _SavedAddressState extends State<SavedAddress> {
  String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    var w = context.watch<AuthServices>();

    return Scaffold(
      backgroundColor: Colors.white,
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
                  BoxShadow(blurRadius: 20, blurStyle: BlurStyle.outer),
                ],
              ),
              child: const Icon(Iconsax.add, color: Colors.black, size: 28),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          FirestoreListView.separated(
            query: addressesCollection.where('uid', isEqualTo: uid),
            padding: EdgeInsets.only(
              left: 22,
              right: 22,
              top: MediaQuery.paddingOf(context).top + 100,
              bottom: MediaQuery.paddingOf(context).bottom + 20,
            ),
            emptyBuilder: (context) {
              return Column(
                children: [
                  const Spacer(),
                  Center(child: Image.asset('assets/images/empty_map.png')),
                  const SizedBox(height: 30),
                  Text(
                    "No saved address",
                    style: TextStyle(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "${"You've not saved any address till now you"} \n ${'can add by tapping button below'}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const Spacer(),
                ],
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 20),
            itemBuilder: (context, doc) {
              AddressModel model = AddressModel.fromMap(doc.data());

              return AddressCard(
                isPrimary: w.primaryAdress == model.id,
                model: model,
                moreWidget: OverflowBar(
                  alignment: MainAxisAlignment.end,
                  children: [
                    AnimatedOpacity(
                      opacity: w.primaryAdress != model.id ? 1 : 0,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.fastEaseInToSlowEaseOut,
                      child: TextButton.icon(
                        onPressed: () {
                          w.updatePrimary(model.id);
                        },
                        icon: const Icon(Iconsax.award),
                        label: const Text("Make primary"),
                      ),
                    ),
                    TextButton.icon(
                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                      icon: const Icon(IconlyLight.delete),
                      onPressed: () {
                        showCupertinoDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              backgroundColor: Colors.white,
                              icon: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: const BoxDecoration(
                                  color: Colors.amber,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Iconsax.info_circle,
                                  size: 32,
                                  color: Colors.white,
                                ),
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Are you sure?",
                                    style: TextStyle(
                                      fontSize: 28.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "This action will remove this address from your list",
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 48),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextButton(
                                          style: TextButton.styleFrom(
                                            foregroundColor: Colors.red,
                                          ),
                                          onPressed: () {
                                            doc.reference.delete();
                                            context.pop();
                                          },
                                          child: Text("Yes, Delete"),
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      Expanded(
                                        child: TextButton(
                                          onPressed: () {
                                            context.pop();
                                          },
                                          child: Text("Cancel"),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      label: Text("Delete"),
                    ),
                  ],
                ),
              );
            },
          ),
          ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.paddingOf(context).top + 10,
                  bottom: 22,
                  left: 22,
                  right: 22,
                ),
                decoration: BoxDecoration(color: Colors.white.withOpacity(.3)),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.pop();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(.1),
                              blurRadius: 2,
                              offset: const Offset(2, 2),
                            ),
                          ],
                        ),
                        child: const Icon(Iconsax.arrow_left),
                      ),
                    ),
                    SizedBox(width: 40.w),
                    Text(
                      "Saved Addresses",
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AddressCard extends StatefulWidget {
  const AddressCard({
    super.key,
    required this.isPrimary,
    required this.model,
    this.moreWidget,
    this.onTap,
  });

  final AddressModel model;
  final Widget? moreWidget;
  final bool isPrimary;
  final VoidCallback? onTap;

  @override
  State<AddressCard> createState() => _AddressCardState();
}

class _AddressCardState extends State<AddressCard> {
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: ScaleButton(
              scale: .985,
              onTap: (widget.moreWidget == null && widget.onTap == null)
                  ? null
                  : () {
                      if (widget.moreWidget != null) {
                        setState(() {
                          isOpen = !isOpen;
                        });
                      } else {
                        widget.onTap!();
                      }
                    },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(width: 1.1, color: Colors.grey.shade300),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.08),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          height: 85,
                          width: 85,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Stack(
                              children: [
                                Image.asset('assets/images/map.jpeg'),
                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      IconlyBold.location,
                                      color: Colors.red,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${"Recipient"} : ${widget.model.name}",
                                style: const TextStyle(fontSize: 18),
                              ),
                              Text(
                                "${"Phone"} : +91 ${widget.model.phone},",
                                style: const TextStyle(fontSize: 12),
                              ),
                              Text(
                                widget.model.address,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (widget.moreWidget != null)
                          const SizedBox(width: 12),
                        if (widget.moreWidget != null)
                          AnimatedRotation(
                            turns: isOpen ? 1.5 : 2,
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.fastEaseInToSlowEaseOut,
                            child: const Icon(
                              Icons.arrow_drop_down_rounded,
                              size: 28,
                            ),
                          ),
                      ],
                    ),
                    if (widget.moreWidget != null)
                      AnimatedCrossFade(
                        firstChild: const SizedBox(
                          width: double.infinity,
                          height: 0,
                        ),
                        secondChild: SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: widget.moreWidget!,
                          ),
                        ),
                        crossFadeState: isOpen
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        duration: const Duration(milliseconds: 400),
                        sizeCurve: Curves.fastEaseInToSlowEaseOut,
                        firstCurve: Curves.fastEaseInToSlowEaseOut,
                        secondCurve: Curves.fastEaseInToSlowEaseOut,
                      ),
                  ],
                ),
              ),
            ),
          ),
          AnimatedScale(
            duration: const Duration(milliseconds: 400),
            scale: widget.isPrimary ? 1 : 0,
            curve: Curves.fastEaseInToSlowEaseOut,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 400),
              opacity: widget.isPrimary ? 1 : 0,
              curve: Curves.fastEaseInToSlowEaseOut,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: Colors.green.shade200, width: 3),
                ),
                child: Text(
                  "Primary",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
