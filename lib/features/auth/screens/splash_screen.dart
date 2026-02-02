import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';

import 'package:go_router/go_router.dart';
import 'package:jal_seva/features/auth/services/auth_services.dart';
import 'package:jal_seva/routing/routes.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  init() async {
    var status = await Geolocator.checkPermission();

    if (status == LocationPermission.denied ||
        status == LocationPermission.deniedForever ||
        status == LocationPermission.unableToDetermine) {
      var r = await Geolocator.requestPermission();

      Fluttertoast.showToast(msg: "Please grand location permission");

      if (r == LocationPermission.denied ||
          r == LocationPermission.deniedForever ||
          r == LocationPermission.unableToDetermine) {
        var r = await Geolocator.openAppSettings();
        if (!r) {
          return;
        }
      }
    }

    if (mounted) {
      if (FirebaseAuth.instance.currentUser == null) {
        context.go(Routes.onboarding.path);
      } else {
        await Provider.of<AuthServices>(context, listen: false).init();
        if (mounted) {
          context.go(Routes.home.path);
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [SizedBox(height: MediaQuery.paddingOf(context).bottom + 30)],
      ),
    );
  }
}
