import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:jal_seva/common/app_colors.dart';
import 'package:jal_seva/routing/routes.dart';

class RootScreen extends StatelessWidget {
  const RootScreen({
    super.key,
    required this.selectedIndex,
    required this.child,
  });

  final int selectedIndex;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(blurRadius: 1000, color: Colors.black.withOpacity(.4)),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.paddingOf(context).bottom,
          ),
          child: SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _bottomItem(
                  iconName: "Home",
                  icon: Iconsax.home_2,
                  selected: selectedIndex == 0,
                  onTap: () {
                    context.go(Routes.home.path);
                  },
                ),
                _bottomItem(
                  iconName: "Order",
                  icon: Iconsax.box,
                  selected: selectedIndex == 1,
                  onTap: () {
                    context.go(Routes.order.path);
                  },
                ),
                _bottomItem(
                  iconName: "wallete",
                  icon: Iconsax.wallet,
                  selected: selectedIndex == 2,
                  onTap: () {
                    context.go(Routes.wallete.path);
                  },
                ),
                _bottomItem(
                  iconName: "Profile",
                  icon: Iconsax.user_octagon,
                  // icon: Iconsax.crown,
                  selected: selectedIndex == 3,
                  onTap: () {
                    // context.go(Routes.subscription.path);
                    context.go(Routes.profile.path);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: child,
    );
  }

  Widget _bottomItem({
    required IconData icon,
    required String iconName,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      height: 78,
      // width: 95,
      child: CupertinoButton(
        onPressed: selected
            ? null
            : () {
                onTap();
              },
        child: Stack(
          children: [
            Column(
              children: [
                Icon(
                  icon,
                  color: selected ? AppColors.appDarkColor : Colors.grey,
                  size: selected ? 27 : 26,
                ),
                const SizedBox(height: 3),
                Text(
                  iconName,
                  style: TextStyle(
                    color: selected ? AppColors.appDarkColor : Colors.grey,
                    fontWeight: selected ? FontWeight.bold : null,
                    fontSize: selected ? 14.sp : 13.sp,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
