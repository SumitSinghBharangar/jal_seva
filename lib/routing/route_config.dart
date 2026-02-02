import 'package:flutter/cupertino.dart';

import 'package:go_router/go_router.dart';
import 'package:jal_seva/features/auth/screens/login_screen.dart';
import 'package:jal_seva/features/auth/screens/onboarding/onbaording_screen.dart';
import 'package:jal_seva/features/auth/screens/otp_screen.dart';
import 'package:jal_seva/features/auth/screens/splash_screen.dart';
import 'package:jal_seva/features/auth/screens/term_use_screen.dart';
import 'package:jal_seva/routing/routes.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _bottomNavKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: Routes.splash.path,
  routes: [
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: Routes.splash.path,
      name: Routes.splash.name,
      pageBuilder: (context, state) {
        return const CupertinoPage(child: SplashScreen());
      },
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: Routes.onboarding.path,
      name: Routes.onboarding.name,
      pageBuilder: (context, state) {
        return const CupertinoPage(child: OnbaordingScreen());
      },
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: Routes.login.path,
      name: Routes.login.name,
      pageBuilder: (context, state) {
        return const CupertinoPage(child: LoginScreen());
      },
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: Routes.otpScreen.path,
      name: Routes.otpScreen.name,
      pageBuilder: (context, state) {
        return const CupertinoPage(child: OtpScreen());
      },
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: Routes.termUseScreen.path,
      name: Routes.termUseScreen.name,
      pageBuilder: (context, state) {
        return CupertinoPage(child: TermUseScreen());
      },
    ),
    // GoRoute(
    //   parentNavigatorKey: _rootNavigatorKey,
    //   path: Routes.savedAddresses.path,
    //   name: Routes.savedAddresses.name,
    //   pageBuilder: (context, state) {
    //     return const CupertinoPage(
    //       child: SavedAddress(),
    //     );
    //   },
    // ),
    // GoRoute(
    //   parentNavigatorKey: _rootNavigatorKey,
    //   path: Routes.transectionScreen.path,
    //   name: Routes.transectionScreen.name,
    //   pageBuilder: (context, state) {
    //     return const CupertinoPage(
    //       child: TransectionScreen(),
    //     );
    //   },
    // ),
    // GoRoute(
    //   parentNavigatorKey: _rootNavigatorKey,
    //   path: Routes.newAddress.path,
    //   name: Routes.newAddress.name,
    //   pageBuilder: (context, state) {
    //     return const CupertinoPage(
    //       child: NewAddressScreen(),
    //     );
    //   },
    // ),
    // GoRoute(
    // parentNavigatorKey: _rootNavigatorKey,
    // GoRoute(
    //   parentNavigatorKey: _rootNavigatorKey,
    //   path: Routes.addressAdded.path,
    //   name: Routes.addressAdded.name,
    //   pageBuilder: (context, state) {
    //     return const CupertinoPage(
    //       child: AddressAddedScreen(),
    //     );
    //   },
    // ),
    // GoRoute(
    //   parentNavigatorKey: _rootNavigatorKey,
    //   path: Routes.newOrder.path,
    //   name: Routes.newOrder.name,
    //   pageBuilder: (context, state) {
    //     return const CupertinoPage(
    //       child: NewOrderScreen(),
    //     );
    //   },
    // ),
    // GoRoute(
    //   parentNavigatorKey: _rootNavigatorKey,
    //   path: Routes.chatScreen.path,
    //   name: Routes.chatScreen.name,
    //   pageBuilder: (context, state) {
    //     return const CupertinoPage(
    //       child: ChatScreen(),
    //     );
    //   },
    // ),

    // GoRoute(
    //   parentNavigatorKey: _rootNavigatorKey,
    //   path: Routes.profileComplete.path,
    //   name: Routes.profileComplete.name,
    //   pageBuilder: (context, state) {
    //     return const CupertinoPage(
    //       child: ProfileCompleteScreen(),
    //     );
    //   },
    // ),
    // GoRoute(
    //   parentNavigatorKey: _rootNavigatorKey,
    //   path: Routes.subscription.path,
    //   name: Routes.subscription.name,
    //   pageBuilder: (context, state) {
    //     return const CupertinoPage(
    //       child: SubscriptionScreen(),
    //     );
    //   },
    // ),
    // GoRoute(
    //   parentNavigatorKey: _rootNavigatorKey,
    //   path: Routes.historyScreen.path,
    //   name: Routes.historyScreen.name,
    //   pageBuilder: (context, state) {
    //     return const CupertinoPage(
    //       child: HistoryScreen(),
    //     );
    //   },
    // ),
    // GoRoute(
    //   parentNavigatorKey: _rootNavigatorKey,
    //   path: Routes.notificationScreen.path,
    //   name: Routes.notificationScreen.name,
    //   pageBuilder: (context, state) {
    //     return const CupertinoPage(
    //       child: NotificationScreen(),
    //     );
    //   },
    // ),
    // GoRoute(
    //   parentNavigatorKey: _rootNavigatorKey,
    //   path: Routes.languageScreen.path,
    //   name: Routes.languageScreen.name,
    //   pageBuilder: (context, state) {
    //     return const CupertinoPage(
    //       child: ChangeLanguageScreen(),
    //     );
    //   },
    // ),
    // GoRoute(
    //   parentNavigatorKey: _rootNavigatorKey,
    //   path: Routes.viewStatusScreen.path,
    //   name: Routes.viewStatusScreen.name,
    //   pageBuilder: (context, state) {
    //     return const CupertinoPage(child: ViewStatusScreen()
    //         // child: OrderDetailScreen(
    //         //   model: state.extra as OrderModel,
    //         // ),
    //         );
    //   },
    // ),
    // GoRoute(
    //   parentNavigatorKey: _rootNavigatorKey,
    //   path: Routes.orderDetail.path,
    //   name: Routes.orderDetail.name,
    //   pageBuilder: (context, state) {
    //     return CupertinoPage(
    //         child: OrderDetailScreen(
    //       model: state.extra as OrderModel,
    //     ));
    //   },
    // ),
    // GoRoute(
    //   parentNavigatorKey: _rootNavigatorKey,
    //   path: Routes.profileEditScreen.path,
    //   name: Routes.profileEditScreen.name,
    //   pageBuilder: (context, state) {
    //     return const CupertinoPage(
    //       child: ProfileEditScreen(),
    //     );
    //   },
    // ),
    // GoRoute(
    //   parentNavigatorKey: _rootNavigatorKey,
    //   path: Routes.orderPlaced.path,
    //   name: Routes.orderPlaced.name,
    //   pageBuilder: (context, state) {
    //     return const CupertinoPage(
    //       child: OrderPlacedScreen(),
    //     );
    //   },
    // ),
    // GoRoute(
    //   parentNavigatorKey: _rootNavigatorKey,
    //   path: Routes.rateOrder.path,
    //   name: Routes.rateOrder.name,
    //   pageBuilder: (context, state) {
    //     return CupertinoPage(
    //       child: OrderRateScreen(
    //         model: state.extra as OrderModel,
    //       ),
    //     );
    //   },
    // ),
    // GoRoute(
    //   parentNavigatorKey: _rootNavigatorKey,
    //   path: Routes.newSubscription.path,
    //   name: Routes.newSubscription.name,
    //   pageBuilder: (context, state) {
    //     return const CupertinoPage(
    //       child: NewSubscriptionScreen(),
    //     );
    //   },
    // ),
    // GoRoute(
    //   parentNavigatorKey: _rootNavigatorKey,
    //   path: Routes.notificationSettingScreen.path,
    //   name: Routes.notificationSettingScreen.name,
    //   pageBuilder: (context, state) {
    //     return const CupertinoPage(
    //       child: NotificationSettingScreen(),
    //     );
    //   },
    // ),
    // GoRoute(
    //   parentNavigatorKey: _rootNavigatorKey,
    //   path: Routes.helpSupportScreen.path,
    //   name: Routes.helpSupportScreen.name,
    //   pageBuilder: (context, state) {
    //     return const CupertinoPage(
    //       child: HelpSupportScreen(),
    //     );
    //   },
    // ),
    // GoRoute(
    //   parentNavigatorKey: _rootNavigatorKey,
    //   path: Routes.feedbackFormScreen.path,
    //   name: Routes.feedbackFormScreen.name,
    //   pageBuilder: (context, state) {
    //     return const CupertinoPage(
    //       child: FeedbackFormScreen(),
    //     );
    //   },
    // ),
    // GoRoute(
    //   parentNavigatorKey: _rootNavigatorKey,
    //   path: Routes.topupScreen.path,
    //   name: Routes.topupScreen.name,
    //   pageBuilder: (context, state) {
    //     return const CupertinoPage(
    //       child: TopupScreen(),
    //     );
    //   },
    // ),
    // GoRoute(
    //   parentNavigatorKey: _rootNavigatorKey,
    //   path: Routes.aboutScreen.path,
    //   name: Routes.aboutScreen.name,
    //   pageBuilder: (context, state) {
    //     return const CupertinoPage(
    //       child: AboutScreen(),
    //     );
    //   },
    // ),
    // GoRoute(
    //   parentNavigatorKey: _rootNavigatorKey,
    //   path: Routes.emptySubscriptionScreen.path,
    //   name: Routes.emptySubscriptionScreen.name,
    //   pageBuilder: (context, state) {
    //     return const CupertinoPage(
    //       child: EmptySubscriptionScreen(),
    //     );
    //   },
    // ),

    // GoRoute(
    //   parentNavigatorKey: _rootNavigatorKey,
    //   path: Routes.subscribed.path,
    //   name: Routes.subscribed.name,
    //   pageBuilder: (context, state) {
    //     return const CupertinoPage(
    //       child: SubscribedScreen(),
    //     );
    //   },
    // ),
    // ShellRoute(
    //   navigatorKey: _bottomNavKey,
    //   parentNavigatorKey: _rootNavigatorKey,
    //   builder: (context, state, child) {
    //     int index = state.fullPath == Routes.home.path
    //         ? 0
    //         : state.fullPath == Routes.order.path
    //             ? 1
    //             : state.fullPath == Routes.wallete.path
    //                 ? 2
    //                 : 3;

    //     return RootScreen(
    //       selectedIndex: index,
    //       child: child,
    //     );
    //   },
    //   routes: [
    //     GoRoute(
    //       path: Routes.home.path,
    //       name: Routes.home.name,
    //       pageBuilder: (context, state) {
    //         return const NoTransitionPage(child: HomeScreen());
    //       },
    //     ),
    //     GoRoute(
    //       path: Routes.wallete.path,
    //       name: Routes.wallete.name,
    //       pageBuilder: (context, state) {
    //         return const NoTransitionPage(child: WalletScreen());
    //       },
    //     ),
    //     GoRoute(
    //       path: Routes.profile.path,
    //       name: Routes.profile.name,
    //       pageBuilder: (context, state) {
    //         return const NoTransitionPage(child: ProfileScreen());
    //       },
    //     ),
    //     GoRoute(
    //       path: Routes.order.path,
    //       name: Routes.order.name,
    //       pageBuilder: (context, state) {
    //         return const NoTransitionPage(child: OrderScreen());
    //       },
    //     ),
    //   ],
    // ),
  ],
  redirect: (context, state) {
    // if (state.fullPath == Routes.home.path) {
    //   if (FirebaseAuth.instance.currentUser?.displayName == null) {
    //     // return Routes.profileComplete.path;
    //   }
    // }
    return null;
  },
);
