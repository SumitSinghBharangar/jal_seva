import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gibili/common/buttons/dynamic_button.dart';
import 'package:gibili/common/enum/enum.dart';
import 'package:gibili/controller/language_change_controller.dart';
import 'package:gibili/features/auth/services/auth_services.dart';
import 'package:gibili/routing/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../../../common/app_colors.dart';
import '../../../common/widgets/language_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final ValueNotifier<bool> isValidate = ValueNotifier<bool>(false);
  ValueNotifier<LanguageCode> selectedLanguage =
      ValueNotifier<LanguageCode>(LanguageCode.en);
  final TextEditingController _phone = TextEditingController();
  bool _agreed = false;

  @override
  void dispose() {
    _phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var l = AppLocalizations.of(context);
    if (l == null) {
      return const SizedBox();
    }
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      LaguageButton(
                        onTap: () {
                          _showLanguageChangeModel();
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
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
                SizedBox(
                  height: 30.h,
                ),
                Text(
                  l.getstartwithgibili,
                  style: TextStyle(
                      fontSize: 19.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 15.h,
                ),
                Text(
                  l.enterMobileNo,
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: Colors.black.withOpacity(0.9),
                  ),
                ),
                SizedBox(
                  height: 7.h,
                ),
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
                      return l.phoneNoCannotbeNull;
                    } else if (value.length != 10) {
                      return l.phoneMustbe10Chars;
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
                SizedBox(
                  height: 5.h,
                ),
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
                            l.iAcceptThe,
                            style: TextStyle(
                              fontSize: 18.sp,
                            ),
                          ),
                          MaterialButton(
                            onPressed: () {
                              if (context.mounted) {
                                context.push(Routes.termUseScreen.path);
                              }
                            },
                            child: Text(
                              l.termOfUse,
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
                                msg: l.pleaseAgreeTermCondition);
                          } else {
                            w.sendOtp(
                                phone: _phone.text,
                                onSend: (_) {
                                  if (_) {
                                    context.go(Routes.otpScreen.path);
                                  }
                                });
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
                SizedBox(
                  height: MediaQuery.paddingOf(context).bottom + 25,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _showLanguageChangeModel() async {
    var l = AppLocalizations.of(context);
    if (l == null) {
      return;
    }
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
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(12),
            ),
            child: Container(
              height: MediaQuery.sizeOf(context).height * .35,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(10),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    SizedBox(
                      height: 15.h,
                    ),
                    Center(
                      child: Container(
                        height: 5.h,
                        width: 30.w,
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Material(
                      child: Text(
                        l.changeLanguage,
                        style: TextStyle(
                          fontSize: 18.sp,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    ValueListenableBuilder<LanguageCode>(
                      valueListenable: selectedLanguage,
                      builder: (context, value, child) {
                        return Column(
                          children: [
                            Material(
                              child: RadioListTile<LanguageCode>(
                                title: Text(
                                  l.english,
                                  style: TextStyle(
                                    fontSize: 17.sp,
                                    color: Colors.black,
                                  ),
                                ),
                                value: LanguageCode.en,
                                groupValue: value,
                                onChanged: (LanguageCode? newValue) {
                                  selectedLanguage.value = newValue!;
                                },
                                controlAffinity: ListTileControlAffinity
                                    .trailing, // Place radio button at trailing
                              ),
                            ),
                            Material(
                              child: RadioListTile<LanguageCode>(
                                title: Text(
                                  l.arabic,
                                  style: TextStyle(
                                      fontSize: 17.sp, color: Colors.black),
                                ),
                                value: LanguageCode.ar,
                                groupValue: value,
                                activeColor: Colors.green,
                                onChanged: (LanguageCode? newValue) {
                                  selectedLanguage.value = newValue!;
                                },
                                controlAffinity: ListTileControlAffinity
                                    .trailing, // Place radio button at trailing
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Consumer<LanguageChangeController>(
                        builder: (context, languageController, child) {
                      return Material(
                        child: DynamicButton.fromText(
                            text: l.setLanguage,
                            onPressed: () {
                              languageController.changeLanguage(
                                Locale(
                                  selectedLanguage.value.toString(),
                                ),
                              );
                              Navigator.pop(context);
                            }),
                      );
                    })
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
