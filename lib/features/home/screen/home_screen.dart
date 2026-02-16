import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:jal_seva/common/animations/fade_in.dart';
import 'package:jal_seva/common/app_colors.dart';
import 'package:jal_seva/common/buttons/scale_button.dart';
import 'package:jal_seva/common/constants/app_collections.dart';
import 'package:jal_seva/features/auth/services/auth_services.dart';

import 'package:jal_seva/routing/routes.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? addressId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchUser();
      // var p = Provider.of<AuthServices>(context, listen: false);
      // addressId = p.primaryAdress;
      // fetchAddress();
    });
  }

  _fetchUser() async {
    FirebaseAuth.instance.currentUser?.displayName == null
        ? context.go(Routes.profileComplete.path)
        : null;
  }

  fetchAddress() async {
    var r = await addressesCollection.doc(addressId).get();

    if (r.exists && r.data() != null) {
    } else {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      var c = await addressesCollection
          .where('uid', isEqualTo: uid)
          .count()
          .get();
      if ((c.count ?? 0) > 0) {
        // _showChangeAddressModal();
      } else {
        if (mounted) {
          context.pop();
          context.push(Routes.newAddress.path);
        }
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var w = context.watch<AuthServices>();

    return Scaffold(
      body: Column(
        children: [
          Container(
            color: AppColors.appDarkColor,
            child: Column(
              children: [
                SizedBox(height: MediaQuery.paddingOf(context).top + 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: FadeInAnimation(
                    delay: .5,
                    child: Row(
                      children: [
                        const Icon(Iconsax.location, color: Colors.white),
                        SizedBox(width: 10.h),
                        Expanded(
                          flex: 9,
                          child: ScaleButton(
                            scale: 0.98,
                            onTap: () {
                              context.push(Routes.savedAddresses.path);
                            },
                            child: Text(
                              w.location ?? "-",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        Expanded(
                          flex: 1,
                          child: IconButton(
                            onPressed: () {
                              // AwesomeNotifications().createNotification(
                              //     content: NotificationContent(
                              //         id: 10,
                              //         channelKey: "basic_channel",
                              //         title: "text notification",
                              //         body: "this notification for testing"));
                              // NotificationManager.instance.send(
                              //   to: FirebaseAuth.instance.currentUser!.uid,
                              //   title: "text message",
                              //   body: "this is text message",
                              //   isUser: true,
                              // );

                              // context.push(Routes.profile.path);
                              context.push(Routes.notificationScreen.path); 
                            },
                            icon: const Icon(
                              Iconsax.notification_bing,
                              color: Colors.white,
                            ),
                            // const Icon(Iconsax.user_octagon),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          Expanded(
            child: SingleChildScrollView(
              // physics: const NeverScrollableScrollPhysics(),
              child: SizedBox(
                // height: MediaQuery.sizeOf(context).height + 200,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FadeInAnimation(
                        delay: 1,
                        child: Image.asset('assets/images/banner2.png'),
                      ),
                      const SizedBox(height: 12),

                      FadeInAnimation(
                        delay: 1.6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionTitle("Our Services"),
                            const SizedBox(height: 16),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: ScaleButton(
                                    onTap: () {
                                      context.push(Routes.newOrder.path);
                                    },
                                    child: Image.asset(
                                      'assets/images/orderCard.png',
                                      height: 185.h,
                                      width: 195.w,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Expanded(
                                  child: ScaleButton(
                                    onTap: () {
                                      // context.push(Routes.newOrder.path);

                                      // Navigator.push(
                                      //     context,
                                      //     CupertinoPageRoute(
                                      //         builder: (context) =>
                                      //             OrderDetailScreen1()));
                                    },
                                    child: Image.asset(
                                      'assets/images/orderCard2.png',
                                      height: 185.h,
                                      width: 185.w,
                                      fit: BoxFit.cover,
                                    ),
                                    // need to change the image with background color....
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),
                      // FadeInAnimation(
                      //   delay: 1.5,
                      //   child: FirestoreListView.separated(
                      //     padding: EdgeInsets.zero,
                      //     shrinkWrap: true,
                      //     physics: const NeverScrollableScrollPhysics(),
                      //     query: ordersCollection
                      //         .where(
                      //           'uid',
                      //           isEqualTo:
                      //               FirebaseAuth.instance.currentUser!.uid,
                      //         )
                      //         .where('isClosed', isEqualTo: false)
                      //         .orderBy('createdAt', descending: true)
                      //         .limit(3),
                      //     separatorBuilder: (context, index) =>
                      //         const SizedBox(height: 10),
                      //     itemBuilder: (context, doc) {
                      //       OrderModel orderModel = OrderModel.fromMap(
                      //         doc.data(),
                      //       );

                      //       return OrderCard(orderModel: orderModel);
                      //     },
                      //   ),
                      // ),
                      // const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

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
}
