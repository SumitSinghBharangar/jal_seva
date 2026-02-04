import 'dart:io';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';


import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';


import 'package:jal_seva/common/app_colors.dart';
import 'package:jal_seva/common/buttons/dynamic_button.dart';
import 'package:jal_seva/common/buttons/scale_button.dart';
import 'package:jal_seva/features/auth/services/auth_services.dart';
import 'package:jal_seva/routing/routes.dart';
import 'package:jal_seva/utils.dart';
import 'package:provider/provider.dart';
import 'package:string_validator/string_validator.dart';

class ProfileCompleteScreen extends StatefulWidget {
  const ProfileCompleteScreen({super.key});

  @override
  State<ProfileCompleteScreen> createState() => _ProfileCompleteScreenState();
}

class _ProfileCompleteScreenState extends State<ProfileCompleteScreen> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _phone = TextEditingController(
    text: FirebaseAuth.instance.currentUser?.phoneNumber.toString() ?? "",
  );
  final TextEditingController _mail = TextEditingController();
  final TextEditingController _userAddress = TextEditingController();
  String? imageUrl;
  File? pickedImage;
  bool imageUploading = false;

  final _fKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _mail.dispose();
    _userAddress.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _phone.text = FirebaseAuth.instance.currentUser?.phoneNumber ?? "";
    WidgetsBinding.instance.addPostFrameCallback((_) {
      imageUrl = FirebaseAuth.instance.currentUser?.photoURL;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Form(
          key: _fKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.paddingOf(context).top + 30),
              Text(
                "Introduce Yourself",
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                "Fill up the following details and let us know you in depth",
                style: TextStyle(fontSize: 17.sp, color: Colors.black),
              ),
              SizedBox(height: 30.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Add Profile Picture",
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
                  if (pickedImage == null)
                    ScaleButton(
                      scale: 0.97,
                      onTap: () async {
                        // await _pickNUpload();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Iconsax.gallery,
                            color: AppColors.buttonColor,
                            size: 23.h,
                          ),
                          SizedBox(width: 7.w),
                          Text(
                            "Upload",
                            style: TextStyle(
                              fontSize: 17.sp,
                              color: AppColors.buttonColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              SizedBox(height: 20.h),
              if (pickedImage != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(.2),
                      shape: BoxShape.circle,
                    ),
                    child: Stack(
                      children: [
                        if (imageUrl == null && pickedImage == null)
                          const Center(child: Icon(Iconsax.image, size: 40)),
                        if (pickedImage != null && imageUrl == null)
                          Positioned.fill(child: Image.file(pickedImage!)),
                        if (imageUrl != null)
                          Positioned.fill(
                            child: Image.network(
                              imageUrl!,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                    if (loadingProgress
                                            ?.cumulativeBytesLoaded ==
                                        null) {
                                      return child;
                                    }
                                    return const SpinKitWaveSpinner(
                                      waveColor: Colors.black,
                                      size: 80,
                                      color: Colors.black,
                                    );
                                  },
                            ),
                          ),
                        if (imageUploading)
                          Positioned.fill(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: const SizedBox.expand(),
                            ),
                          ),
                        if (imageUploading)
                          Container(color: Colors.white.withOpacity(.3)),
                        if (imageUploading)
                          const Align(
                            alignment: Alignment.center,
                            child: SpinKitWaveSpinner(
                              waveColor: Colors.black,
                              size: 80,
                              color: Colors.black,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 30),
              TextFormField(
                controller: _name,
                onTapOutside: (event) {
                  FocusScope.of(context).unfocus();
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "This field is required";
                  }
                  if (value.length < 3) {
                    return "Must Have 3 Chars";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 14.h,
                    horizontal: 14.w,
                  ),
                  hintText: "Name",
                ),
              ),
              SizedBox(height: 16.h),
              TextFormField(
                controller: _mail,
                onTapOutside: (event) {
                  FocusScope.of(context).unfocus();
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "This field is required";
                  }
                  if (!value.isEmail) {
                    return "Invalid Mail";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 14.h,
                    horizontal: 14.w,
                  ),
                  hintText: "Email Address",
                ),
              ),
              SizedBox(height: 16.h),
              TextFormField(
                controller: _phone,
                onTapOutside: (event) {
                  FocusScope.of(context).unfocus();
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 14.h,
                    horizontal: 14.h,
                  ),
                  hintText: "Enter Phone Number",
                ),
              ),
              const Spacer(),
              const Spacer(),
              DynamicButton(
                onPressed: _fKey.currentState?.validate() ?? false
                    ? () async {
                        if (imageUrl == null) {
                          Fluttertoast.showToast(
                            msg: "Please select a profile picture",
                          );
                        } else {
                          showLoading(context);
                          await _updateProfile();
                          if (context.mounted) {
                            context.pop();
                            context.go(Routes.home.path);
                          }
                        }
                      }
                    : null,
                child: Text(
                  "Continue",
                  style: TextStyle(
                    fontSize: 17.h,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _updateProfile() async {
    if (imageUploading) {
      Fluttertoast.showToast(
        msg: "Please wait while image is uploading",
      );
      return;
    }

    if (_fKey.currentState?.validate() ?? false) {
      await Provider.of<AuthServices>(context, listen: false).updateProfile(
        name: _name.text,
        phone: _phone.text,
        mail: _mail.text,
        imageUrl: imageUrl!,
      );

      if (mounted) {
        context.go(Routes.home.path);
      }
    }
  }

  // Future<void> _pickNUpload() async {
  //   var r = await ImagePicker().pickImage(source: ImageSource.gallery);
  //   if (r != null) {
  //     imageUrl = null;
  //     pickedImage = File(r.path);
  //     imageUploading = true;
  //     setState(() {
  //       var u = FirebaseAuth.instance.currentUser?.uid;
  //       var ref = FirebaseStorage.instance.ref(u);
  //       ref = ref.child('profilePicture');
  //       ref.putData(pickedImage!.readAsBytesSync()).whenComplete(() async {
  //         String url = await ref.getDownloadURL();
  //         imageUrl = url;
  //         await FirebaseAuth.instance.currentUser?.updatePhotoURL(url);
  //         await FirebaseAuth.instance.currentUser?.reload();
  //         imageUploading = false;
  //         setState(() {});
  //       });
  //     });
  //     // var c = await ImageCropper().cropImage(
  //     //     sourcePath: r.path,
  //     //     aspectRatio: const CropAspectRatio(ratioX: 2, ratioY: 2));
  //     // if (c != null) {
  //     //   imageUrl = null;
  //     //   pickedImage = File(c.path);
  //     //   imageUploading = true;
  //     //   setState(() {});

  //     // }
  //   }
  // }
}
