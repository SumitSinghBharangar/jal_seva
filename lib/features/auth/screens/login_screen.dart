import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:jal_seva/common/buttons/dynamic_button.dart';
import 'package:jal_seva/features/auth/services/auth_services.dart';
import 'package:jal_seva/routing/routes.dart';
import 'package:provider/provider.dart';
import '../../../common/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final ValueNotifier<bool> isValidate = ValueNotifier<bool>(false);

  final TextEditingController _phone = TextEditingController();
  bool _agreed = false;

  @override
  void dispose() {
    _phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var w = context.watch<AuthServices>();

    return Scaffold(
      body: ListView(
        children: [
          Container(
            height: 600.h,
            color: const Color(0xFFA3FDCD),
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 40.h),
                  Image.asset(
                    "assets/icons/project_icon.png",
                    height: 400.h,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30.h),
                Text(
                  "Get started with Jal Seva",
                  style: TextStyle(
                    fontSize: 19.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 15.h),
                Text(
                  "Enter your mobile no",
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: Colors.black.withOpacity(0.9),
                  ),
                ),
                SizedBox(height: 7.h),
                TextFormField(
                  controller: _phone,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onTapOutside: (event) {
                    FocusScope.of(context).unfocus();
                  },
                  decoration: InputDecoration(
                    prefixText: "+966 ",
                    prefixIcon: const Icon(Iconsax.call),
                    prefixStyle: const TextStyle(color: Colors.black),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1.0.w),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.black, width: 1.0.w),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Phone no can not be null";
                    } else if (value.length != 10) {
                      return "Phone Must be of 10 character";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      if (value.length == 10) {
                        isValidate.value = true;
                        FocusScope.of(context).unfocus();
                      } else {
                        isValidate.value = false;
                      }
                    });
                  },
                ),
                SizedBox(height: 5.h),
                FractionallySizedBox(
                  widthFactor: 1,
                  child: Center(
                    child: FittedBox(
                      child: Flex(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        direction: Axis.horizontal,
                        children: [
                          Checkbox(
                            activeColor: AppColors.buttonColor,
                            focusColor: Colors.indigoAccent,
                            hoverColor: Colors.indigoAccent,
                            value: _agreed,
                            onChanged: (_) {
                              setState(() {
                                _agreed = !_agreed;
                              });
                            },
                          ),
                          Text(
                            "I accept the",
                            style: TextStyle(fontSize: 18.sp),
                          ),
                          MaterialButton(
                            onPressed: () {
                              if (context.mounted) {
                                context.push(Routes.termUseScreen.path);
                              }
                            },
                            child: Text(
                              "Term Of Use",
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                                decorationThickness: 2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                DynamicButton(
                  isLoading: w.isLoading,
                  onPressed: isValidate.value
                      ? () {
                          if (!_agreed) {
                            Fluttertoast.showToast(
                              msg: "Please agree to our Terms & conditions",
                            );
                          } else {
                            w.sendOtp(
                              phone: _phone.text,
                              onSend: (issended) {
                                if (issended) {
                                  context.go(Routes.otpScreen.path);
                                }
                              },
                            );
                          }
                        }
                      : null,
                  child: Text(
                    "Send OTP",
                    style: TextStyle(
                      fontSize: 19.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                // DynamicButton.fromText(
                //   isLoading: w.isLoading,
                //   onPressed: () {

                //   },
                //   text: "SEND OTP",
                // ),
                SizedBox(height: MediaQuery.paddingOf(context).bottom + 25),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
