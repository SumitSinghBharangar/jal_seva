import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:jal_seva/common/animations/fade_in.dart';
import 'package:jal_seva/common/app_colors.dart';
import 'package:jal_seva/common/buttons/dynamic_button.dart';
import 'package:jal_seva/common/buttons/scale_button.dart';
import 'package:jal_seva/common/constants/app_collections.dart';
import 'package:jal_seva/features/subscription/model/subscription_model.dart';
import 'package:jal_seva/routing/routes.dart';
import 'package:shimmer/shimmer.dart';
import 'package:carousel_slider/carousel_slider.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  SubscriptionModel? model;
  String uid = FirebaseAuth.instance.currentUser!.uid;

  fetch() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    // context.push(Routes.emptySubscriptionScreen.path);

    var r = await subscriptionsCollection
        .where("uid", isEqualTo: uid)
        .limit(1)
        .get();

    if (r.docs.isEmpty) {
      if (mounted) {
        context.push(Routes.emptySubscriptionScreen.path);

        print("move to new subscription screen");
      }
    } else {
      setState(() {
        model = SubscriptionModel.fromMap(r.docs.first.data());
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetch();
    });
  }

  @override
  Widget build(BuildContext context) {
    
    final List<String> imgList = [
      'assets/images/subscriptionbg.png',
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(
           "Your Subscription",
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.appDarkColor,
        centerTitle: false,
        leading: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: Icon(
              Icons.arrow_back,
              size: 28.h,
              color: Colors.white,
            )),
      ),
      body: (model == null)
          ? Shimmer.fromColors(
              baseColor: Colors.grey.withOpacity(0.4),
              highlightColor: Colors.grey.shade400,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 22.w),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10 + 16 + 32,
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.5),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(.05),
                              blurRadius: 20,
                              offset: const Offset(0, 2),
                            )
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FractionallySizedBox(
                              widthFactor: .6,
                              child: Container(
                                height: 16,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 16.h,
                            ),
                            FractionallySizedBox(
                              widthFactor: .4,
                              child: Container(
                                height: 12,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 16.h,
                            ),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(.5),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(.05),
                                      blurRadius: 20,
                                      offset: const Offset(0, 2),
                                    )
                                  ]),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FractionallySizedBox(
                                    widthFactor: .6,
                                    child: Container(
                                      height: 16.h,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 16.h,
                                  ),
                                  FractionallySizedBox(
                                    widthFactor: .4,
                                    child: Container(
                                      height: 12.h,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 16.h,
                                  ),
                                  FractionallySizedBox(
                                    widthFactor: .4,
                                    child: Container(
                                      height: 12.h,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 16.h,
                                  ),
                                  FractionallySizedBox(
                                    widthFactor: .4,
                                    child: Container(
                                      height: 12.h,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 16.h,
                            ),
                            Container(
                              height: MediaQuery.sizeOf(context).height * .3,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(.05),
                                      blurRadius: 20,
                                      offset: const Offset(0, 2),
                                    )
                                  ]),
                              width: double.infinity,
                            ),
                            SizedBox(
                              height: 16.h,
                            ),
                            Container(
                              height: MediaQuery.sizeOf(context).height * .3,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(.05),
                                      blurRadius: 20,
                                      offset: const Offset(0, 2),
                                    )
                                  ]),
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FractionallySizedBox(
                                    widthFactor: .4,
                                    child: Container(
                                      height: 12.h,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 16.h,
                                  ),
                                  FractionallySizedBox(
                                    widthFactor: .4,
                                    child: Container(
                                      height: 12.h,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  FractionallySizedBox(
                                    widthFactor: .4,
                                    child: Container(
                                      height: 12.h,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 16.h,
                                  ),
                                  FractionallySizedBox(
                                    widthFactor: .4,
                                    child: Container(
                                      height: 12.h,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          : Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  FadeInAnimation2(
                    delay: 1,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)),
                      padding: EdgeInsets.all(8.h),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                 "Subscrition Status",
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const Spacer(),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color:
                                      model!.status == SubscriptionStatus.active
                                          ? Colors.blue
                                          : model!.status ==
                                                  SubscriptionStatus.paused
                                              ? Colors.yellow
                                              : Colors.red,
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8.w, vertical: 4),
                                child: Center(
                                  child: Text(
                                    model!.status.name,
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey.shade200,
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15.w, vertical: 10.h),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                         "Subscribed On",
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      Text(
                                        DateFormat('d MMM yyyy')
                                            .format(model!.createdAt),
                                        style: TextStyle(
                                          fontSize: 18.sp,
                                          color: Colors.black,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 15.w,
                              ),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey.shade200,
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15.w, vertical: 10.h),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Renew Date",
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      Text(
                                        DateFormat('d MMM yyyy')
                                            .format(model!.reNewDate),
                                        style: TextStyle(
                                          fontSize: 18.sp,
                                          color: Colors.black,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                child: ScaleButton(
                                  scale: 0.97,
                                  onTap: () async {
                                    try {
                                      var ref =
                                          subscriptionsCollection.doc(uid);
                                      final snapshot = await ref.get();
                                      if (snapshot.exists) {
                                        final data = snapshot.data()
                                            as Map<String, dynamic>;

                                        if (model != null &&
                                            model!.status ==
                                                SubscriptionStatus.active) {
                                          if (data['status'] == 'active') {
                                            await ref.update({
                                              'status': 'paused',
                                              'pausedAt':
                                                  FieldValue.serverTimestamp(),
                                            });
                                            Fluttertoast.showToast(
                                                msg: "Subscription Paused");
                                            await fetch();
                                          } else {
                                            throw Exception(
                                                "Subscription already paused");
                                          }
                                        } else {
                                          if (data['status'] == 'paused' &&
                                              data['pausedAt'] != null) {
                                            final Timestamp pausedAt =
                                                data['pausedAt'];
                                            final Timestamp currentTime =
                                                Timestamp.now();
                                            final int pausedDurationInSeconds =
                                                currentTime.seconds -
                                                    pausedAt.seconds;

                                            await ref.update({
                                              'status': 'active',
                                              'pausedAt': null,
                                              'reNewDate': Timestamp(
                                                data['reNewDate'].seconds +
                                                    pausedDurationInSeconds,
                                                0,
                                              ),
                                            });
                                            Fluttertoast.showToast(
                                                msg: "Subscription resumed.");
                                            await fetch();
                                          } else {
                                            throw Exception(
                                                'Subscription is not paused.');
                                          }
                                        }
                                      } else {
                                        throw Exception(
                                            
                                                "Subscriptin Not found");
                                      }
                                    } catch (e) {
                                      Fluttertoast.showToast(msg: 'Error: $e');
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: model != null &&
                                                model!.status ==
                                                    SubscriptionStatus.paused
                                            ? Colors.yellow
                                            : Colors.blue,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.white,
                                    ),
                                    padding: const EdgeInsets.all(8),
                                    child: Center(
                                      child: Text(
                                        model != null &&
                                                model!.status ==
                                                    SubscriptionStatus.active
                                            ? "Pause"
                                            : "Resume",
                                        style: TextStyle(
                                          color: model != null &&
                                                  model!.status ==
                                                      SubscriptionStatus.paused
                                              ? Colors.yellow
                                              : Colors.blue,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Visibility(
                                visible: model != null &&
                                    model!.status != SubscriptionStatus.expired,
                                child: Flexible(
                                  child: ScaleButton(
                                    scale: 0.97,
                                    onTap: () async {
                                      try {
                                        var ref =
                                            subscriptionsCollection.doc(uid);
                                        var snapshot = await ref.get();
                                        if (snapshot.exists) {
                                          final data = snapshot.data()
                                              as Map<String, dynamic>;
                                          if (data['status'] != 'cancelled') {
                                            await ref.update(
                                                {'status': 'cancelled'});
                                            Fluttertoast.showToast(
                                                msg: "Subscription cancelled.");
                                          } else {
                                            Fluttertoast.showToast(
                                                msg:
                                                    "Subscription already cancelled.");
                                          }
                                        } else {
                                          throw Exception(
                                              'Subscription not found.');
                                        }
                                      } catch (e) {
                                        Fluttertoast.showToast(
                                            msg: 'Error: $e');
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.red,
                                      ),
                                      padding: const EdgeInsets.all(8),
                                      child: Center(
                                        child: Text(
                                           "Cancel",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Flexible(
                                child: ScaleButton(
                                  scale: 0.97,
                                  onTap: () {
                                    Fluttertoast.showToast(
                                        msg: 
                                            "Renew functionality not implemented yet.");
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey.shade400),
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.white,
                                    ),
                                    padding: const EdgeInsets.all(8),
                                    child: Center(
                                      child: Text(
                                         "Renew",
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
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
                        .map((item) => Center(
                              child: Image.asset(
                                item,
                                fit: BoxFit.cover,
                                width: 1000,
                              ),
                            ))
                        .toList(),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  // _buildDeliveryInfoSection(),
                  // const SizedBox(height: 20),
                  // FadeInAnimation2(
                  //     delay: 1.5, child: _buildSubscriptionDetails()),
                  // const SizedBox(height: 20),
                  // FadeInAnimation2(delay: 2, child: _buildMapSection()),
                  // const SizedBox(height: 30),
                  // FadeInAnimation(
                  //   delay: 2.5,
                  //   child: Center(
                  //     child: _buildActionButton("Renew Plan",
                  //         model == null ? AppColors.buttonColor : Colors.grey),
                  //   ),
                  // ),
                ],
              ),
            ),
    );
  }

  // Modern Design for Subscription Details
  Widget _buildSubscriptionDetails() {
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: _buildCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle( "Subscription Details",
              Icons.subscriptions_outlined),
          SizedBox(height: 10.h),
          _buildInfoRow( "ID", model!.id),
          _buildInfoRow( "Started From",
              DateFormat("EEE, dd/MM/yy").format(model!.createdAt)),
          _buildInfoRow('Plan', model!.plan.name),
        ],
      ),
    );
  }

  // Custom Map Section
  Widget _buildMapSection() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.35,
      decoration: _buildCardDecoration(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: GoogleMap(
          myLocationButtonEnabled: false,
          initialCameraPosition: CameraPosition(
            target: LatLng(
                model!.address.lat.toDouble(), model!.address.lng.toDouble()),
            zoom: 14,
          ),
          markers: {
            Marker(
              markerId: const MarkerId('delivery-location'),
              position: LatLng(
                model!.address.lat.toDouble(),
                model!.address.lng.toDouble(),
              ),
            ),
          },
        ),
      ),
    );
  }

  // Action Button
  Widget _buildActionButton(String text, Color color) {
    return DynamicButton(
      foregroundColor: Colors.white,
      onPressed: model == null
          ? () {
              context.push(Routes.newSubscription.path);
            }
          : null,
      child: Text(
        "Renew Plan",
        style: TextStyle(
            fontSize: 19.sp, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  // Card Decoration without Gradient
  BoxDecoration _buildCardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  // Section Title with Icon
  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.teal, size: 28),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  // Info Row with Custom Styling
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          RichText(
              textAlign: TextAlign.end,
              text: TextSpan(
                text: value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.black54,
                ),
              ))
        ],
      ),
    );
  }
}