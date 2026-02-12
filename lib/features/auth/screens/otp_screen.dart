import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:go_router/go_router.dart';
import 'package:jal_seva/common/app_colors.dart';
import 'package:jal_seva/common/buttons/dynamic_button.dart';
import 'package:jal_seva/features/auth/services/auth_services.dart';
import 'package:jal_seva/routing/routes.dart';

import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final ValueNotifier<bool> isValidate = ValueNotifier<bool>(false);
  final TextEditingController _otp = TextEditingController();

  final ValueNotifier<int> _timer = ValueNotifier<int>(59);
  late Timer _countdownTimer;

  startTimer() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timer.value > 0) {
        _timer.value--;
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _countdownTimer.cancel();
    _timer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var w = context.watch<AuthServices>();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.paddingOf(context).top + 50),
            Text(
              "Verify Yourself",
              style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
            ),
            Text(
              "Enter the verification send to ${w.phoneNumber} in order to continue the journey",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            Pinput(
              length: 6,
              controller: _otp,
              defaultPinTheme: PinTheme(
                width: 60,
                height: 70,
                textStyle: TextStyle(fontSize: 22.sp, color: Colors.black),
                decoration: BoxDecoration(
                  color: Colors.grey[200], // Light grey background color
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              focusedPinTheme: PinTheme(
                width: 60,
                height: 73,
                textStyle: TextStyle(fontSize: 22.sp, color: Colors.black),
                decoration: BoxDecoration(
                  color: Colors.grey[200], // Keep color the same when focused
                  borderRadius: BorderRadius.circular(11),
                  border: Border.all(
                    color: Colors.black.withOpacity(0.5),
                  ), // Thin black border when focused
                ),
              ),
              onTapOutside: (event) {
                FocusScope.of(context).unfocus();
              },
              onChanged: (value) {
                setState(() {
                  value.length == 6
                      ? isValidate.value = true
                      : isValidate.value = false;
                });
              },
              autofocus: true,
            ),
            SizedBox(height: 30.h),
            DynamicButton(
              onPressed: isValidate.value
                  ? () async {
                      var r = await w.verifyOTP(otp: _otp.text);
                      if (r) {
                        Fluttertoast.showToast(msg: "Login successfull");
                        // if (context.mounted) {
                        //   context.go(Routes.home.path);
                        // }
                      } else {
                        Fluttertoast.showToast(msg: "Invalid OTP");
                      }
                    }
                  : null,
              child: Text(
                "Verify",
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 12),
            ValueListenableBuilder(
              valueListenable: _timer,
              builder: (context, value, _) {
                return AnimatedCrossFade(
                  firstChild: Row(
                    children: [
                      Text(
                        "We will resend the code in",
                        style: TextStyle(fontSize: 16.sp),
                      ),
                      Text(
                        "${value}s",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  secondChild: Row(
                    children: [
                      MaterialButton(
                        onPressed: () {
                          w.resend(
                            onSend: (_) {
                              _timer.value = 59;
                              startTimer();
                            },
                          );
                        },
                        child: Text(
                          "Resend Code",
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.buttonColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  crossFadeState: value == 0
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 400),
                );
              },
            ),
            const SizedBox(height: 16),
            SizedBox(height: 10 + MediaQuery.paddingOf(context).bottom),
          ],
        ),
      ),
    );
  }
}
